classdef SingleTestInfo
    %SINGLETESTINFO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % fixed
        MulRanBaseDir_
        KITTIBaseDir_
        OxfordBaseDir_
        NaverLabsBaseDir_

        % user input 
        dataset_
        sequence_
        dataset_dir_
        method_
        res_
        roi_
        num_candidates_

        % dataset-dependant
        scan_dir_
        scan_names_
        scan2_dir_
        scan2_names_
        scan2_times_
        
        gtpose_path_ 
        gtpose_
        gtpose_time_
        gtpose_xyz_
        gtpose_xy_
        gtpose_rpy_
        gtpose_6d_
        gtpose_se3_
        gtlidarpose_xyz_
        gtlidarpose_se3_

        % save 
        SaveBaseDir_
        save_path_
        save_path_core_
        
    end
    
    methods
        function obj = SingleTestInfo(dataset, seq, method, res, roi, num_candidates)
            %% default 
            obj.MulRanBaseDir_ = '/media/user/My Passport/data/MulRan_release/';
            obj.KITTIBaseDir_ = '/media/user/GS1TB/KITTI/dataset/sequences/';
            obj.OxfordBaseDir_ = '/media/user/GS1TB/OxfordRadar/sequences/';
            obj.NaverLabsBaseDir_ = '/media/user/NAVER_LABS_DATAS/outdoor_dataset/ForTRO/';

            obj.SaveBaseDir_ = 'data';

            %% basic
            obj.dataset_ = dataset;
            obj.sequence_ = seq;
            obj.method_ = method;
            obj.res_ = res;
            obj.roi_ = roi;
            obj.num_candidates_ = num_candidates;
            
            %% dataset-dependant 
            % MulRan 
            if( strcmp( obj.dataset_, 'MulRan') )
                obj.dataset_dir_ = fullfile(obj.MulRanBaseDir_, obj.sequence_);
                obj.scan_dir_ = fullfile( obj.dataset_dir_, 'sensor_data/Ouster/' );
                obj.scan_names_ = osdir(obj.scan_dir_);

                obj.gtpose_path_ = fullfile( obj.dataset_dir_, 'global_pose.csv' );
                obj.gtpose_ = csvread( obj.gtpose_path_ );
                obj.gtpose_time_ = obj.gtpose_(:, 1);
                obj.gtpose_xyz_ = obj.gtpose_(:, [5, 9, 13]);
                obj.gtpose_xy_ = obj.gtpose_xyz_(:, 1:2);

            % KITTI 
            elseif( strcmp( obj.dataset_, 'KITTI') )
                obj.dataset_dir_ = fullfile(obj.KITTIBaseDir_, obj.sequence_);
                obj.scan_dir_ = fullfile( obj.dataset_dir_, 'velodyne/' );
                obj.scan_names_ = osdir(obj.scan_dir_);

                obj.gtpose_path_ = fullfile( obj.dataset_dir_, 'poses.txt' );
                obj.gtpose_ = dlmread( obj.gtpose_path_ );
                obj.gtpose_xyz_ = obj.gtpose_(:, [4, 8, 12]); % WARNING: in camera coord
                obj.gtpose_xy_ = obj.gtpose_xyz_(:, [1, 3]); % WARNING: in camera coord so use x,z in cam coord as x,y in lidar coord.

                obj.gtpose_time_ = dlmread( fullfile( obj.dataset_dir_, 'times.txt' ) );
%                 obj.gtpose_time_ = linspace(1, length(obj.gtpose_), length(obj.gtpose_)); % KITTI has no time
                              
            % Oxford 
            elseif( strcmp( obj.dataset_, 'Oxford') )
                obj.dataset_dir_ = fullfile(obj.OxfordBaseDir_, obj.sequence_);
                obj.scan_dir_ = fullfile( obj.dataset_dir_, 'velodyne_left/' );
                obj.scan_names_ = osdir(obj.scan_dir_);
                obj.scan2_dir_ = fullfile( obj.dataset_dir_, 'velodyne_right/' );
                obj.scan2_names_ = osdir(obj.scan2_dir_);

                for ii_scan2_bin_name = obj.scan2_names_
                    ii_scan2_bin_time = str2double(ii_scan2_bin_name{1}(1:end-4));
                    obj.scan2_times_ = [obj.scan2_times_; ii_scan2_bin_time];
                end

                % parse pose 
                % oxford pose reader: ref https://github.com/ori-mrg/robotcar-dataset-sdk/blob/master/matlab/InterpolatePoses.m                 
                obj.gtpose_path_ = fullfile( obj.dataset_dir_, 'gps/ins.csv' );

                ins_file_id = fopen(obj.gtpose_path_); 
                headers = textscan(ins_file_id, '%s', 15, 'Delimiter',',');
                format_str = '%u64 %s %f %f %f %f %f %f %s %f %f %f %f %f %f';
                ins_data = textscan(ins_file_id, format_str,'Delimiter',',');
                fclose(ins_file_id);
               
                obj.gtpose_ = ins_data;

                obj.gtpose_time_ = double(obj.gtpose_{1});
                northings = obj.gtpose_{6}; % y
                eastings = obj.gtpose_{7}; % x
                downs = obj.gtpose_{8}; % z 
                rolls = obj.gtpose_{13};
                pitches = obj.gtpose_{14};
                yaws = obj.gtpose_{15};
                obj.gtpose_xyz_ = [eastings, northings, downs];
                obj.gtpose_xy_ = obj.gtpose_xyz_(:, [1, 2]);
                obj.gtpose_rpy_ = [rolls, pitches, yaws];

                obj.gtpose_6d_ = [obj.gtpose_xyz_, obj.gtpose_rpy_];
                obj.gtpose_se3_ = {};
                for ii = 1:length(obj.gtpose_6d_)
                    pose_6d = obj.gtpose_6d_(ii, :);
                    pose_xyz = pose_6d(1:3);
                    pose_euler = pose_6d(4:6); 
                    pose_so3 = RotmatFromEuler(flip(pose_euler));
                    pose_se3 = [pose_so3, pose_xyz'; 0,0,0, 1];
                    obj.gtpose_se3_{end+1} = pose_se3;
                end
                
                base2lidar_se3 = [RotmatFromEuler(flip([pi, pi, 0])), [1.13, 0, -1.24]'; 0,0,0,1];
                lidar2base_se3 = inv(base2lidar_se3);

                % ref: makeLiDARGTposes.m (head2tail is required)                
                obj.gtlidarpose_se3_ = {};
                
                obj.gtlidarpose_se3_{end+1} = eye(4);
                obj.gtlidarpose_xyz_(1, :) = [0,0,0];
                
                lidarpose_prev = eye(4);
                obj.gtlidarpose_xyz_ = zeros(length(obj.gtpose_6d_), 3);
                for ii = 2:length(obj.gtpose_6d_)
                    basepose_prev = obj.gtpose_se3_{ii-1};
                    basepose_curr = obj.gtpose_se3_{ii};

                    rel_base2base = inv(basepose_prev) * basepose_curr;
                    
                    rel_lidar2lidar = lidar2base_se3 * rel_base2base * base2lidar_se3;
                    lidarpose_curr = lidarpose_prev * rel_lidar2lidar;

                    obj.gtlidarpose_se3_{end+1} = lidarpose_curr;
                    obj.gtlidarpose_xyz_(ii, :) = lidarpose_curr(1:3, 4);
        
                    lidarpose_prev = lidarpose_curr;
                end
                
            % NaverLabs 
            elseif( strcmp( obj.dataset_, 'NaverLabs') )
                obj.dataset_dir_ = fullfile(obj.NaverLabsBaseDir_, obj.sequence_);
                obj.scan_dir_ = fullfile( obj.dataset_dir_, 'lidars/' );
                obj.scan_names_ = osdir(obj.scan_dir_);

                obj.gtpose_path_ = fullfile( obj.dataset_dir_, 'poses.txt' );
                obj.gtpose_ = dlmread( obj.gtpose_path_ );
%                 obj.gtpose_time_ = linspace(1, length(obj.gtpose_), length(obj.gtpose_)); % not consider time in this experiment
                obj.gtpose_time_ = dlmread( fullfile(obj.dataset_dir_, 'timestamps.txt') );
                obj.gtpose_xyz_ = obj.gtpose_(:, [4, 8, 12]);
                obj.gtpose_xy_ = obj.gtpose_xyz_(:, 1:2);
                
                obj.gtpose_se3_ = {};
                for ii = 1:length(obj.gtpose_)
                    pose_se3line = obj.gtpose_(ii, :);
                    pose_se3 = reshape(pose_se3line, 4, 4)';
                    obj.gtpose_se3_{end+1} = pose_se3;
                end
                
                base2lidar_se3 = [0.999853669, 0.006310318, 0.0159003363, 1.09403653; ...
                                  -0.006315622,0.999980016,0.0002834088,-0.01908349; ...
                                  -0.01589823,-0.000383787,0.999873541,0.354; ...
                                  0,0,0,1];
                lidar2base_se3 = inv(base2lidar_se3);
                
                % ref: makeLiDARGTposes.m (head2tail is required)                
                obj.gtlidarpose_se3_ = {};
                
                obj.gtlidarpose_se3_{end+1} = eye(4);
                obj.gtlidarpose_xyz_(1, :) = [0,0,0];
                
                lidarpose_prev = eye(4);
                obj.gtlidarpose_xyz_ = zeros(length(obj.gtpose_6d_), 3);
                for ii = 2:length(obj.gtpose_time_)
                    basepose_prev = obj.gtpose_se3_{ii-1};
                    basepose_curr = obj.gtpose_se3_{ii};

                    rel_base2base = inv(basepose_prev) * basepose_curr;
                    
                    rel_lidar2lidar = lidar2base_se3 * rel_base2base * base2lidar_se3;
                    lidarpose_curr = lidarpose_prev * rel_lidar2lidar;

                    obj.gtlidarpose_se3_{end+1} = lidarpose_curr;
                    obj.gtlidarpose_xyz_(ii, :) = lidarpose_curr(1:3, 4);
        
                    lidarpose_prev = lidarpose_curr;
                end
                
            end
           
            %% save 
            obj.save_path_core_ = fullfile( obj.SaveBaseDir_, ...
                            strcat( ...
                                obj.dataset_, '-', obj.sequence_, '-', obj.method_, '-', ...
                                num2str(obj.res_(1)), 'x', num2str(obj.res_(2)), '-', num2str(obj.num_candidates_) ... 
                            ) ... 
                        );

            [curr_time, ~] = clock;
            curr_time_int = round(curr_time);
            curr_time_str = regexprep(num2str(curr_time_int), ' +', '');
            obj.save_path_ = fullfile( obj.save_path_core_, curr_time_str );  

        end
        
    end
end


%% helper funcs
function [files] = osdir(path)
    files = dir(path); files(1:2) = []; files = {files(:).name};
end

