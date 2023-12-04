function [descs, invkeys, poses] = loadDataV2EquiDistXYZT(testinfo, SKIP_FRAMES)
        
%% Newely make
    if ~ exist(testinfo.save_path_core_, 'dir')  

        % make 
        [descs, invkeys, poses] = makeExperienceEquiDistXYZT(testinfo, SKIP_FRAMES);    

        % save 
        mkdir(testinfo.save_path_);

        descs_filename = fullfile(testinfo.save_path_, 'descs.mat');
        invkeys_filename = fullfile(testinfo.save_path_, 'invkeys.mat');
        poses_filename = fullfile(testinfo.save_path_, 'poses.mat');

        save(descs_filename, 'descs');
        save(invkeys_filename, 'invkeys');
        save(poses_filename, 'poses');
        
        disp('- successfully made.');

        %% Or load existing ones 
    else
        saved_time = osdir(testinfo.save_path_core_); saved_time = saved_time{1};
        descs_filename = fullfile(testinfo.save_path_core_, saved_time, 'descs.mat');
        invkeys_filename = fullfile(testinfo.save_path_core_, saved_time, 'invkeys.mat');
        poses_filename = fullfile(testinfo.save_path_core_, saved_time, 'poses.mat');

        load(descs_filename);
        % fix
        for desc_idx = 1:length(descs)
            desc = double(descs{desc_idx});
            descs{desc_idx} = desc;
        end

        load(invkeys_filename);
        load(poses_filename);

        disp('- successfully loaded.');
    end

end

