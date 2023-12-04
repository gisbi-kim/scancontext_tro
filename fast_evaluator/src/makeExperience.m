function [scancontexts, ringkeys, xy_poses] = makeExperience(data_dir, shape, skip_data_frame)

%%
num_rings = shape(1);
num_sectors = shape(2);

%%
lidar_data_dir = strcat(data_dir, 'velodyne/');
data_names = osdir(lidar_data_dir);

%% gps to xyz
gtpose = csvread(strcat(data_dir, '00.csv'));
% gtpose_time = gtpose(:, 1);
gtpose_xy = gtpose(:, [4,12]);


%%
num_data = length(data_names);
num_data_save = floor(num_data/skip_data_frame) + 1;
save_counter = 1;

scancontexts = cell(1, num_data_save);
ringkeys = zeros(num_data_save, num_rings);
xy_poses = zeros(num_data_save, 2);

for data_idx = 1:num_data
    
    if(rem(data_idx, skip_data_frame) ~=0)
        continue;
    end
    
    file_name = data_names{data_idx};
    data_time = str2double(file_name(1:end-4));
    data_path = strcat(lidar_data_dir, file_name);
    
    % get
    ptcloud = readBin(data_path);
    sc = Ptcloud2ScanContext(ptcloud, shape(2), shape(1), 80); % up to 80 meter

    rk = ringkey(sc);
    
%     [nearest_time_gap, nearest_idx] = min(abs(repmat(data_time, length(gtpose_time), 1) - gtpose_time));
    xy_pose = gtpose_xy(data_idx, :);
    
    % save 
    scancontexts{save_counter} = sc;
    ringkeys(save_counter, :) = rk;
    xy_poses(save_counter, :) = xy_pose;
    save_counter = save_counter + 1;
    
    % log
    if(rem(data_idx, 100) == 0)
        message = strcat(num2str(data_idx), " / ", num2str(num_data), " processed (skip: ", num2str(skip_data_frame), ")");
        disp(message); 
    end
end

scancontexts = scancontexts(1:save_counter-1);
ringkeys = ringkeys(1:save_counter-1, :);
xy_poses = xy_poses(1:save_counter-1, :);


end
