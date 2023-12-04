function [scan_global] = local2global_fast(scan, lidar_to_base_init_se3, scan_pose_se3)

scan_hmg = [scan, ones(length(scan), 1)]';
scan_global_hmg = scan_pose_se3 * lidar_to_base_init_se3 * scan_hmg; % remember this order (left multiplication!)
scan_global = scan_global_hmg(1:3, :)';

end

