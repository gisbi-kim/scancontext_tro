function [descs_list, invkeys_list, xy_poses] = makeAugmentedExperienceEquiDistTreeMerge(testinfo, SKIP_FRAMES)

%% 
LIDAR_HEIGHT = 1.9;

%%
num_data = length(testinfo.scan_names_);
num_data_save = floor(num_data/SKIP_FRAMES) + 1;

save_counter = 1;

num_invaxis = testinfo.res_(1);
% num_vaxis = testinfo.res_(2);

%% aug save vars (currently supports only pc, 20200513)
NUM_AUG_SCs = 3; % including the original (no-root-shifted)

descs_list = {};
invkeys_list = {};

for idx_copies = 1:NUM_AUG_SCs
    descs_list{end+1} = cell(1, num_data_save);
    invkeys_list{end+1} = zeros(num_data_save, num_invaxis);
end

xy_poses = zeros(num_data_save, 2);


ENOUGH_MOVEMENT_GAP = 1; % meter 
bfr_xy = [0, 0]; % init 
cur_xy = bfr_xy;
accum_movement = 0;

%% main parse 
for scan_idx = 1:num_data
% for scan_idx = 1:10000
    
    %% curr info 
    if(rem(scan_idx, SKIP_FRAMES) ~=0)
        continue;
    end
    
    scan_name = testinfo.scan_names_{scan_idx};
    scan_time = str2double(scan_name(1:end-4));
    scan_path = strcat(testinfo.scan_dir_, scan_name);
    
    
    %% load datat 
    if( strcmp(testinfo.dataset_, 'MulRan') )
        try
            points = readBin(scan_path);
        catch
            continue;
        end
        [~, nearest_idx] = min(abs(repmat(scan_time, length(testinfo.gtpose_time_), 1) - testinfo.gtpose_time_));
        xy_pose = testinfo.gtpose_xy_(nearest_idx, :);

    elseif( strcmp(testinfo.dataset_, 'KITTI') )
        points = readBin(scan_path);
        xy_pose = testinfo.gtpose_xy_(scan_idx, :);     
        
    elseif( strcmp(testinfo.dataset_, 'Oxford') )
%         points = readBinOxford(scan_path);
%         [~, nearest_idx] = min(abs(repmat(scan_time, length(testinfo.gtpose_time_), 1) - testinfo.gtpose_time_));
%         xy_pose = testinfo.gtpose_xy_(nearest_idx, :);

        [~, near_scan2_idx] = min( abs(testinfo.scan2_times_ - scan_time) );
        scan2_name = testinfo.scan2_names_{near_scan2_idx};
        scan2_path = strcat(testinfo.scan2_dir_, scan2_name);

        points_left = readBinOxford(scan_path);
        points_left(:,2) = points_left(:,2) + 0.47;
        
        points_right = readBinOxford(scan2_path);
        points_right(:,2) = points_right(:,2) - 0.47;

        points = [points_left; points_right];
        
        [~, nearest_idx] = min(abs(repmat(scan_time, length(testinfo.gtpose_time_), 1) - testinfo.gtpose_time_));
        xy_pose = testinfo.gtpose_xy_(nearest_idx, :);

        
%         figure(1); clf;
%         pcshow(points);
%         xlim([-80, 80]); ylim([-80, 80]); zlim([-5, 20]);
        
    elseif( strcmp(testinfo.dataset_, 'NaverLabs') )
        points = readScanNaverlabs(scan_path);
        xy_pose = testinfo.gtpose_xy_(scan_idx, :);     

    end


    %% check enough movement 
%     ENOUGH_MOVEMENT_GAP = 1;
    cur_xy = xy_pose;
    accum_movement = accum_movement + norm(cur_xy - bfr_xy);
    bfr_xy = cur_xy; % reset 
    if( accum_movement < ENOUGH_MOVEMENT_GAP)
        continue;
    else
        accum_movement = 0;
    end
    
    %% description: ptcloud to descriptor 
    % different for the method 
    
    % pc
    if( strcmp(testinfo.method_, 'pc') )
        points(:, 3) = points(:, 3) + LIDAR_HEIGHT;
        ptcloud = pointCloud(points);
        
        num_sector = testinfo.res_(2);
        num_ring = testinfo.res_(1);
        max_range = testinfo.roi_(1); 

        desc_list = ptcloud2polarcontextAug(ptcloud, num_sector, num_ring, max_range, NUM_AUG_SCs); % up to 80 meter
        
    % cc
    elseif(  strcmp(testinfo.method_, 'cc') )
        points(:, 3) = points(:, 3) + LIDAR_HEIGHT;
        ptcloud = pointCloud(points);

%         unit_move =  round( testinfo.roi_(1)*2 / testinfo.res_(1) );
%         unit_lateral = round( testinfo.roi_(2)*2 / testinfo.res_(2) );
        unit_move =  ( testinfo.roi_(1)*2 / testinfo.res_(1) );
        unit_lateral = ( testinfo.roi_(2)*2 / testinfo.res_(2) );
        axis_unit = [unit_move, unit_lateral];
        axis_range = testinfo.roi_;
        
        desc = ptcloud2cartcontext(ptcloud, axis_unit, axis_range); % up to 80 meter            
        ikey = sc2invkey(desc); 

    % m2dp
    elseif(  strcmp(testinfo.method_, 'm2dp') )
        ptcloud_down = pcdownsample(pointCloud(points), 'gridAverage', 0.1);
        [desc, ~] = M2DP(ptcloud_down.Location);
        ikey = 0; % dummy  
    end
    
%     figure(1); clf;
%     imagesc(desc);
%     colormap jet; caxis([0, 4]); axis equal;
      
    
    %% 20200810 debugger:to see the point cloud 
%     if(save_counter == 1056 || save_counter == 2714)
%        disp(1); 
%     end

    
    %% save 
    for idx_aug = 1:NUM_AUG_SCs
        desc = desc_list{idx_aug};

        ikey = sc2invkey(desc);         
%         ikey = sc2invkeyL0(desc); 
        
        descs_list{idx_aug}{save_counter} = desc;
        invkeys_list{idx_aug}(save_counter, :) = ikey; % for only cc and pc (not for M2DP and pnvlad)       
    end
 
    xy_poses(save_counter, :) = xy_pose;

    save_counter = save_counter + 1;
    
    % log
    if(rem(scan_idx, 100) == 0)
        message = strcat(num2str(scan_idx), " / ", num2str(num_data), " processed (skip: ", num2str(SKIP_FRAMES), ")");
        disp(message); 
    end
    
%     figure(13); clf;
%     xy_poses_show = xy_poses;
%     xy_poses_show = xy_poses_show(1:save_counter-1, :);
%     scatter(xy_poses_show(:, 1), xy_poses_show(:, 2)); axis equal;

end

% take valids 
for idx_aug = 1:NUM_AUG_SCs
    descs_list{idx_aug} = descs_list{idx_aug}(1:save_counter-1);
    invkeys_list{idx_aug} = invkeys_list{idx_aug}(1:save_counter-1, :);
end

xy_poses = xy_poses(1:save_counter-1, :);

end

