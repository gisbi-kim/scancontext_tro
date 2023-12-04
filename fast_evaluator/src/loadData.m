function [scancontexts, ringkeys, poses] = loadData(down_shape, skip_data_frame)

%%
global data_path;
data_save_path = fullfile('data/'); 

%%
% newly make
if exist(data_save_path) == 0 
    % make 
    [scancontexts, ringkeys, poses] = makeExperience(data_path, down_shape, skip_data_frame);    
    
    % save
    mkdir(data_save_path);

    filename = strcat(data_save_path, 'scancontexts', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    save(filename, 'scancontexts');
    filename = strcat(data_save_path, 'ringkeys', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    save(filename, 'ringkeys');
    filename = strcat(data_save_path, 'poses', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    save(filename, 'poses');

% or load 
else
    filename = strcat(data_save_path, 'scancontexts', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    load(filename);
    % fix
    for iii = 1:length(scancontexts)
        sc = double(scancontexts{iii});
        scancontexts{iii} = sc;
    end
    
    filename = strcat(data_save_path, 'ringkeys', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    load(filename);
    filename = strcat(data_save_path, 'poses', num2str(down_shape(1)), 'x', num2str(down_shape(2)), '.mat');
    load(filename);
    
    disp('- successfully loaded.');
end

%%
disp(' ');

end

