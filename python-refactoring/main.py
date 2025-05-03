#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
import numpy as np
from sensor_msgs.msg import PointCloud2
import sensor_msgs.point_cloud2 as pc2
from std_msgs.msg import Header
from datetime import datetime
from scan_context import ScanContext  # scan_context.py 에 정의된 클래스

class ScanContextNode:
    def __init__(self):
        rospy.init_node('scan_context_node', anonymous=True)

        # 구독 주기 조절용
        self.last_callback_time = rospy.Time.now()
        self.min_interval = rospy.Duration.from_sec(0.1)  # kHz로 제한하고 싶을 경우

        # Scan Context 객체
        self.sc = ScanContext()
        self.init_sc(self.sc)

        self.db_size = 0


        # 구독자 설정
        self.sub = rospy.Subscriber("/os_cloud_node/points", PointCloud2, self.callback, queue_size=1)

    def init_sc(self, _sc):
        # ScanContext 초기화
        _sc.exclude_recent = 3
        _sc.sample_step = 100

    def callback(self, msg):
        # 콜백 호출 주기 제한
        now = rospy.Time.now()
        if (now - self.last_callback_time) < self.min_interval:
            return
        self.last_callback_time = now

        # PointCloud2를 numpy로 변환
        pc = list(pc2.read_points(msg, field_names=("x", "y", "z"), skip_nans=True))
        pc_np = np.array(pc, dtype=np.float32)

        if pc_np.shape[0] == 0:
            rospy.logwarn("Received empty point cloud.")
            return

        # ScanContext DB에 추가
        self.sc.add_descriptor(pc_np)
        self.db_size += 1

        # Loop Closure 탐지
        nearest_id, nearest_yaw_diff_deg, nearest_dist = self.sc.find_nearest()

        # 로그 출력
        timestamp = msg.header.stamp.to_sec()
        log_msg = f"[{datetime.fromtimestamp(timestamp)}] Frame {self.db_size - 1} added. "

        if nearest_dist < self.sc.dist_thres:
            log_msg += f"LOOP with ID {nearest_id}, SC dist: {nearest_dist:.3f} < threshold {self.sc.dist_thres:.3f}, Yaw diff: {nearest_yaw_diff_deg:.1f} deg."
        else:
            log_msg += f"No loop closure detected (SC dist: {nearest_dist:.3f} from place id {nearest_id})."

        rospy.loginfo(log_msg)


if __name__ == '__main__':
    try:
        node = ScanContextNode()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
