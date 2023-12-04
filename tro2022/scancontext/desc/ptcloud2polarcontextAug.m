function [ imgs_cell ] = ptcloud2polarcontextAug( ptcloud_in, num_sector, num_ring, max_range, NUM_NEIGHBOR )
%% NOTE
% date: 2020. 05. 05
% update: 2020. 07. 20

%% Preprocessing 
VIZFIG_IDX = 321;
IF_VISFIG = 0;
if(IF_VISFIG)
figure(VIZFIG_IDX); clf;
end

% Downsampling for fast search
gridStep = 0.5; % 0.5m cubic grid downsampling is applied in the paper. 
ptcloud_orig = pcdownsample(ptcloud_in, 'gridAverage', gridStep);

% point cloud information 
gap = max_range / num_ring; 
angle_one_sector = 360/num_sector;

% aug main 
imgs_cell = {};
% lateral_move_aug_list = [-4, -2, 0, 2, 4];
% lateral_move_aug_list = [-4, -2, 0, 2, 4];

SHIFT_LEN = 2.0; % at iros18 used 3m

% 8 neighbor 
% NUM_NEIGHBOR = myself (orig) + num neighbors 
% NUM_NEIGHBOR = 7;

% order: orig, east (-y), west (+y), south (-x), north (+x), es (-y, -x), ws (+y, -x), en (-y, +x), wn (+y, +x)
% 8 aug ver
% move_aug_list = [0, 0         , 0,         -SHIFT_LEN, SHIFT_LEN, -SHIFT_LEN, SHIFT_LEN , -SHIFT_LEN, SHIFT_LEN; ...
%                  0, -SHIFT_LEN, SHIFT_LEN, 0         , 0        , -SHIFT_LEN, -SHIFT_LEN, SHIFT_LEN , SHIFT_LEN];

% 5 aug ver
move_aug_list = [0, 0         , 0,         -SHIFT_LEN, SHIFT_LEN , -SHIFT_LEN, SHIFT_LEN; ...
                 0, -SHIFT_LEN, SHIFT_LEN, -SHIFT_LEN, -SHIFT_LEN, SHIFT_LEN , SHIFT_LEN];

% for move_idx = 1:size(move_aug_list, 2)
for move_idx = 1:NUM_NEIGHBOR

    xyz_orig = ptcloud_orig.Location;

    x_move_ith_neighbor = move_aug_list(1, move_idx);
    y_move_ith_neighbor = move_aug_list(2, move_idx);
    
    T = [ 1 0 0 x_move_ith_neighbor; 0 1 0 y_move_ith_neighbor; 0 0 1 0; 0 0 0 1];
    ptcloud_moved = [xyz_orig, ones(length(xyz_orig), 1) ];
    ptcloud_ith_neighbor = inv(T) * transpose(ptcloud_moved);

    ptcloud_ith_neighbor = transpose(ptcloud_ith_neighbor);
    xyz_aug = ptcloud_ith_neighbor(:, 1:3);
    
    ptcloud_root_shifted = pointCloud(xyz_aug);
    num_points = ptcloud_root_shifted.Count;
    
    % debug 
    if (IF_VISFIG)
    rand_color = repmat(rand(1,3), ptcloud_root_shifted.Count, 1); 
    figure(VIZFIG_IDX);
    pcshow(ptcloud_root_shifted.Location, rand_color); hold on; 
    end    
    
    %% vacant bins 
    cell_bins = cell(num_ring, num_sector);
    cell_bin_counter = ones(num_ring, num_sector);

    enough_large = 500; % for fast and constant time save, We contain maximum 500 points per each bin.
    enough_small = -10000;
    for ith_ring = 1:num_ring
       for ith_sector = 1:num_sector
            bin = enough_small * ones(enough_large, 3);
            cell_bins{ith_ring, ith_sector} = bin;
       end
    end


    %% Save a point to the corresponding bin 
    for ith_point =1:num_points

        % Point information 
        ith_point_xyz = ptcloud_root_shifted.Location(ith_point,:);
        ith_point_r = sqrt(ith_point_xyz(1)^2 + ith_point_xyz(2)^2);
        ith_point_theta = xy2theta(ith_point_xyz(1), ith_point_xyz(2)); % degree

        % Find the corresponding ring index 
        tmp_ring_index = floor(ith_point_r/gap);
        if(tmp_ring_index >= num_ring)
            ring_index = num_ring;
        else
            ring_index = tmp_ring_index + 1;
        end

        % Find the corresponding sector index 
        tmp_sector_index = ceil(ith_point_theta/angle_one_sector);
        if(tmp_sector_index == 0)
            sector_index = 1;
        elseif(tmp_sector_index > num_sector || tmp_sector_index < 1)
            sector_index = num_sector;
        else
            sector_index = tmp_sector_index;
        end

        % Assign point to the corresponding bin cell 
        try
            corresponding_counter = cell_bin_counter(ring_index, sector_index); % 1D real value.
        catch
            continue;
        end
        cell_bins{ring_index, sector_index}(corresponding_counter, :) = ith_point_xyz;
        cell_bin_counter(ring_index, sector_index) = cell_bin_counter(ring_index, sector_index) + 1; % increase count 1

    end


    %% bin to image format (2D matrix) 
    img = zeros(num_ring, num_sector);

    min_num_thres = 5; % a bin with few points, we consider it is noise.

    % Find maximum Z value of each bin and Save into img 
    for ith_ring = 1:num_ring
        for ith_sector = 1:num_sector
            value_of_the_bin = 0;            
            points_in_bin_ij = cell_bins{ith_ring, ith_sector};

            if( IsBinHaveMoreThanMinimumPoints(points_in_bin_ij, min_num_thres, enough_small) )
                value_of_the_bin = max(points_in_bin_ij(:, 3));
            else
                value_of_the_bin = 0;      
            end

            img(ith_ring, ith_sector) = value_of_the_bin;    
        end
    end


    imgs_cell{end+1} = img;
    
end


end % end of the main function 


function bool = IsBinHaveMoreThanMinimumPoints(mat, minimum_thres, enough_small)

min_thres_point = mat(minimum_thres, :);

if( isequal(min_thres_point, [ enough_small, enough_small, enough_small]) )
    bool = 0;
else
    bool = 1;
end

end
