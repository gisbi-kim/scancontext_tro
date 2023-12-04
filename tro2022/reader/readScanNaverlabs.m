function [ pc_xyz ] = readScanNaverlabs( global_path )

pc_info = double(readNPY(global_path));
pc_xyz = pc_info(:, 1:3) / 100; % because original cm  
% ptcloud = pointCloud(pc_xyz);
% ptcloud.Intensity = pc_info(:, 4);

end

