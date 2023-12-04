function points = readBinOxford(bin_path)
   
%% Read 
% fid = fopen(bin_path, 'rb'); raw_data = fread(fid, [4 inf], 'single'); fclose(fid);
% points = raw_data(1:3,:)'; 

velodyne_file = fopen(bin_path);
data = fread(velodyne_file, 'single');
fclose(velodyne_file);
pointcloud = reshape(data, [numel(data)/4  4]);
points = pointcloud(:, 1:3);
points(:, 3) = -1 * points(:, 3); % because hdl32e lidar was mounted vertically reversed. see https://oxford-robotics-institute.github.io/radar-robotcar-dataset/documentation
% 근데 이렇게 바꾸면 엄밀하진 않다. (좌우가 바뀌어버림) 

% ptcloud = pointCloud(points);

end % end of function
