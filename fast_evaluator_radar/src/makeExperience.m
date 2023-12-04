function [scancontexts, ringkeys, xy_poses] = makeExperience(data_dir, shape)

%%
num_rings = shape(1);
num_sectors = shape(2);

%%
radar_data_dir = fullfile(data_dir, 'sensor_data/radar/polar/');
data_names = osdir(radar_data_dir);

%% gps to xyz
gtpose = csvread(strcat(data_dir, 'global_pose.csv'));
gtpose_time = gtpose(:, 1);
gtpose_xy = gtpose(:, [5,9]);

% figure(1); hold on;
% plot(traj_x, traj_y);

%%
num_data = length(data_names);

scancontexts = cell(1, num_data);
ringkeys = zeros(num_data, num_rings);
xy_poses = zeros(num_data, 2);

for data_idx = 1:num_data
    file_name = data_names{data_idx};
    data_time = str2double(file_name(1:end-4));
    data_path = strcat(radar_data_dir, file_name);
    
    % get
    sc = imread(data_path);
    sc = imresize(sc, shape);
    sc = double(sc);

    rk = ringkey(sc);
    
    [nearest_time_gap, nearest_idx] = min(abs(repmat(data_time, length(gtpose_time), 1) - gtpose_time));
    xy_pose = gtpose_xy(nearest_idx, :);
    
    % save 
    scancontexts{data_idx} = sc;
    ringkeys(data_idx, :) = rk;
    xy_poses(data_idx, :) = xy_pose;
   
    % log
    if(rem(data_idx, 100) == 0)
        message = strcat(num2str(data_idx), " / ", num2str(num_data), " processed.");
        disp(message); 
    end
end

end

