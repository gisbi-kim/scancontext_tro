function [descs, invkeys, xy_poses] = makeExperience(testinfo, SKIP_FRAMES)

%% 
LIDAR_HEIGHT = 1.9;

%%
num_data = length(testinfo.scan_names_);
num_data_save = floor(num_data/SKIP_FRAMES) + 1;

save_counter = 1;

num_invaxis = testinfo.res_(1);
% num_vaxis = testinfo.res_(2);

descs = cell(1, num_data_save);
invkeys = zeros(num_data_save, num_invaxis);
xy_poses = zeros(num_data_save, 2);

for scan_idx = 1:num_data
    
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
        points = readBinOxford(scan_path);
        [~, nearest_idx] = min(abs(repmat(scan_time, length(testinfo.gtpose_time_), 1) - testinfo.gtpose_time_));
        xy_pose = testinfo.gtpose_xy_(nearest_idx, :);
        
        % debug oxford
%         figure(1); clf;
%         pcshow(points); colormap jet; caxis([0, 10]);
%         xlim([-80, 80]); ylim([-80, 80]); zlim([0, 20]);
%         xlabel('x (moving)'); ylabel('y (lateral)');
%         view(0, 90);
        
    elseif( strcmp(testinfo.dataset_, 'NaverLabs') )
        points = readScanNaverlabs(scan_path);
        xy_pose = testinfo.gtpose_xy_(scan_idx, :);     

    end

    
    %% description: ptcloud to descriptor 
    % different for the method 
    
    % ccpoints
    if( strcmp(testinfo.method_, 'pc') )
        points(:, 3) = points(:, 3) + LIDAR_HEIGHT;
        ptcloud = pointCloud(points);
        
        num_sector = testinfo.res_(2);
        num_ring = testinfo.res_(1);
        max_range = testinfo.roi_(1); 

        desc = ptcloud2polarcontext(ptcloud, num_sector, num_ring, max_range); % up to 80 meter
        ikey = sc2invkey(desc); 
        
    % pc
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
 
%         figure(2); clf;
% %         subplot(1,2, 2);
% %         desc_viz = flip( flip(desc, 2), 1);
%         imagesc(desc); 
%         colormap jet; caxis([0, 10]);


    % m2dp
    elseif(  strcmp(testinfo.method_, 'm2dp') )
        ptcloud_down = pcdownsample(pointCloud(points), 'gridAverage', 0.1);
        [desc, ~] = M2DP(ptcloud_down.Location);
        ikey = 0; % dummy  
    end
          
    
    %% save 
    descs{save_counter} = desc;
    invkeys(save_counter, :) = ikey; % for only cc and pc (not for M2DP and pnvlad)
    xy_poses(save_counter, :) = xy_pose;

    save_counter = save_counter + 1;

    xy = xy_poses(1:save_counter-1, :);

%     if(length(xy) > 3)
%         figure(3); clf;
%         xyt = [xy, linspace(1, 0.01 * length(xy), length(xy))'];
%         pcshow(xyt, 'MarkerSize', 100);
%         colormap jet;
%     end

    % log
    if(rem(scan_idx, 100) == 0)
        message = strcat(num2str(scan_idx), " / ", num2str(num_data), " processed (skip: ", num2str(SKIP_FRAMES), ")");
        disp(message); 
    end
    
end

% take valids 
descs = descs(1:save_counter-1);
invkeys = invkeys(1:save_counter-1, :);
xy_poses = xy_poses(1:save_counter-1, :);


end

