function [scan_local] = global2local_fast(scan, lidar_to_base_init_se3, scan_pose_se3)

scan_global_hmg = [scan, ones(size(scan, 1), 1)]';
scan_hmg = inv(lidar_to_base_init_se3) * inv(scan_pose_se3) * scan_global_hmg;
scan_local = scan_hmg(1:3, :)';

end

