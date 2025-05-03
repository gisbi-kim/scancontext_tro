#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import numpy as np
from sensor_msgs.msg import PointCloud2, NavSatFix
import sensor_msgs.point_cloud2 as pc2
from std_msgs.msg import Header
from datetime import datetime
from collections import deque
from pyproj import Proj
import os
from scan_context import ScanContext  # scan_context.py 에 정의된 클래스

class ScanContextNode:
    def __init__(self):
        rospy.init_node('scan_context_node', anonymous=True)

        # 콜백 주기 조절 (Hz 제한)
        self.last_callback_time = rospy.Time.now()
        self.min_interval = rospy.Duration.from_sec(0.1)  # 예: 10Hz 처리

        # ScanContext 설정
        self.sc = ScanContext()
        self.init_sc(self.sc)
        self.db_size = 0
        self.timestamps = []  # 각 LiDAR frame의 timestamp 저장

        # GPS 관련 설정
        self.gps_buffer = deque(maxlen=100)  # 최근 GPS 기록 저장
        self.utm_proj = Proj(proj='utm', zone=52, ellps='WGS84', south=False)  # 대전 기준

        # 로그 파일 초기화
        log_path = os.path.expanduser("./scan_context_log.txt")
        self.log_file = open(log_path, "a")

        # ROS topic 구독
        self.sub = rospy.Subscriber("/os_cloud_node/points", PointCloud2, self.callback, queue_size=1)
        self.gps_sub = rospy.Subscriber("/gps/fix", NavSatFix, self.gps_callback, queue_size=1)

    def init_sc(self, _sc):
        _sc.exclude_recent = 30
        _sc.sample_step = 100

    def gps_callback(self, msg):
        stamp = msg.header.stamp.to_sec()
        lat, lon = msg.latitude, msg.longitude
        self.gps_buffer.append((stamp, lat, lon))

    def find_closest_gps(self, query_time):
        if not self.gps_buffer:
            return None
        gps_times = np.array([abs(t - query_time) for t, _, _ in self.gps_buffer])
        min_idx = np.argmin(gps_times)
        return self.gps_buffer[min_idx]

    def callback(self, msg):
        now = rospy.Time.now()
        if (now - self.last_callback_time) < self.min_interval:
            return
        self.last_callback_time = now

        # PointCloud2 → numpy 변환
        pc = list(pc2.read_points(msg, field_names=("x", "y", "z"), skip_nans=True))
        pc_np = np.array(pc, dtype=np.float32)
        if pc_np.shape[0] == 0:
            rospy.logwarn("Received empty point cloud.")
            return

        # ScanContext 업데이트
        timestamp = msg.header.stamp.to_sec()
        self.sc.add_descriptor(pc_np, timestamp=timestamp)
        self.timestamps.append(timestamp)
        self.db_size += 1

        # Loop closure 탐지
        nearest_id, nearest_yaw_diff_deg, nearest_dist = self.sc.find_nearest()

        # 현재 GPS 위치
        gps_info = self.find_closest_gps(timestamp)
        if gps_info:
            _, lat, lon = gps_info
            utm_x, utm_y = self.utm_proj(lon, lat)
            gps_str = f"curr_utm=({utm_x:.1f}, {utm_y:.1f})"
        else:
            gps_str = "curr_utm=(N/A)"

        # loop 후보 GPS 위치 및 시간
        if nearest_id >= 0 and nearest_id < len(self.timestamps):
            loop_time = self.timestamps[nearest_id]
            loop_time_str = datetime.fromtimestamp(loop_time)
            loop_gps_info = self.find_closest_gps(loop_time)
            if loop_gps_info:
                _, loop_lat, loop_lon = loop_gps_info
                loop_utm_x, loop_utm_y = self.utm_proj(loop_lon, loop_lat)
                loop_str = f"nearest_utm=({loop_utm_x:.1f}, {loop_utm_y:.1f}), time={loop_time_str}"
            else:
                loop_str = f"nearest_utm=(N/A), time={loop_time_str}"
        else:
            loop_str = "nearest_utm=(N/A), time=(N/A)"

        # 로그 출력
        log_msg = f"[{datetime.fromtimestamp(timestamp)}] Frame {self.db_size - 1} added. {gps_str} \n {loop_str} "

        if nearest_dist < self.sc.dist_thres:
            log_msg += f"\n \u2705 LOOP with ID {nearest_id}, SC dist: {nearest_dist:.3f} < threshold {self.sc.dist_thres:.3f}, Yaw diff: {nearest_yaw_diff_deg:.1f} deg."
        else:
            log_msg += f"\n \u274C No loop closure detected (SC dist: {nearest_dist:.3f} from place id {nearest_id})."

        # 두 UTM 간 거리 출력
        if 'utm_x' in locals() and 'loop_utm_x' in locals():
            distance_m = np.linalg.norm(np.array([utm_x, utm_y]) - np.array([loop_utm_x, loop_utm_y]))
            log_msg += f"\n UTM dist: {distance_m:.2f} m"

        log_msg += "\n"
        rospy.loginfo(log_msg)
        self.log_file.write(log_msg + "\n")
        self.log_file.flush()

    def __del__(self):
        if hasattr(self, 'log_file') and self.log_file:
            self.log_file.close()

if __name__ == '__main__':
    try:
        node = ScanContextNode()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
