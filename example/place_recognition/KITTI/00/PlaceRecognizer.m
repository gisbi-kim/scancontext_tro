clear; clc;
addpath(genpath('../../../../matlab/'));

%% Change this to your path
% vel_dir = '/media/gskim/Data/KITTI odo/data_odometry_velodyne/dataset/sequences/00/velodyne/';
vel_dir = 'your_pointcloud_files_path';


%% Params
% below 3 parameters: same setting as the original paper (G. Kim, 18 IROS)
max_range = 80; % meter 
num_sectors = 60;
num_rings = 20; 

num_candidates = 50; % means Scan Context-50 in the paper.

loop_thres = 0.2; % ### this is a user parameter ###

num_enough_node_diff = 50; 


%% Main
load('GTposes.mat');

ringkeys = [];
scancontexts = {};

loop_log = [];
num_nodes = length(GTposes);
for ith_node = 1:num_nodes-1
    
    % information 
    idx_query = ith_node;
    ptcloud = KITTIbin2PtcloudWithIndex(vel_dir, idx_query);

    sc_query = Ptcloud2ScanContext(ptcloud, num_sectors, num_rings, max_range);
    scancontexts{end+1} = sc_query; % save into database
    
    % ringkey tree
    ringkey = ScanContext2RingKey(sc_query);
    ringkeys = [ringkeys; ringkey];
    tree = createns(ringkeys, 'NSMethod', 'kdtree'); % Create object to use in k-nearest neighbor search

    % try loop-detection after enough moving 
    if(ith_node < num_candidates)
        continue;
    end

    % find nearest candidates 
    candidates = knnsearch(tree, ringkey, 'K', num_candidates); 

    % check dist btn candidates is lower than the given threshold.
    idx_nearest = 0;
    min_dist = inf; % initialization 
    for ith_candidate = 1:length(candidates)
        
        idx_candidate = candidates(ith_candidate);
        sc_candidate = scancontexts{idx_candidate};

        % skip condition: do not check nearest measurements 
        if( abs(idx_query - idx_candidate) < num_enough_node_diff)
            continue;
        end

        % Main 
        distance_to_query = DistanceBtnScanContexts(sc_query, sc_candidate);
        if( distance_to_query > loop_thres)
            continue; 
        end
            
        if( distance_to_query < min_dist)
            idx_nearest = idx_candidate;
            min_dist = distance_to_query;
        end
            
    end

    % log the result 
    if( ~isequal(min_dist, inf)) % that is, when any loop (satisfied under acceptance theshold) occured.
        pose_dist_real = DistBtn2Dpose(GTposes(idx_query,:), GTposes(idx_nearest,:));
        loop_log = [loop_log; ...
                    idx_query, idx_nearest, min_dist, pose_dist_real];
    end
    
    %% Log Message: procedure and LoopFound Event  
    if( rem(idx_query, 100) == 0)
        disp( strcat(num2str(idx_query), '.bin processed') );
    end
    if( ~isequal(min_dist, inf) )
       disp( strcat("Loop found: ", num2str(idx_query), " <-> ", num2str(idx_nearest), " with dist ", num2str(min_dist)));
    end
    
end


%% Save the result into csv file 
save_dir = strcat('./result/', num2str(num_candidates),'/', num2str(loop_thres), '/');
save_file_name = strcat(save_dir, '/LogLoopFound.csv');
if( ~exist(save_dir))
    mkdir(save_dir)
end
csvwrite(save_file_name, loop_log);



