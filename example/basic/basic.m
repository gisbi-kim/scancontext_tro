clear; clc;
addpath(genpath('../../matlab/'));


%% Parameters 
data_dir = '../../sample_data/KITTI/00/velodyne/';

basic_max_range = 80; % meter 
basic_num_sectors = 60;
basic_num_rings = 20;


%% Visualization of ScanContext 
bin_path = [data_dir, '000094.bin'];
ptcloud = KITTIbin2Ptcloud(bin_path);
sc = Ptcloud2ScanContext(ptcloud, basic_num_sectors, basic_num_rings, basic_max_range);

h1 = figure(1); clf;
imagesc(sc);
set(gcf, 'Position', [10 10 800 300]);
xlabel('sector'); ylabel('ring');

% for vivid visualization
colormap jet;
caxis([0, 4]); % KITTI00 is usually in z: [0, 4]


%% Making Ringkey and maintaining kd-tree
% Read the PlaceRecognizer.m


%% ScanContext with different resolution 

figure(2); clf;
pcshow(ptcloud); colormap jet; caxis([0 4]);

res = [0.25, 0.5, 1, 2, 3]; 

h2=figure(3); clf;
set(gcf, 'Position', [10 10 500 1000]);

for i = 1:length(res)
    num_sectors = basic_num_sectors * res(i);
    num_rings = basic_num_rings * res(i);
    
    sc = Ptcloud2ScanContext(ptcloud, num_sectors, num_rings, basic_max_range);

    subplot(length(res), 1, i);
    imagesc(sc); hold on;
    colormap jet;
    caxis([0, 4]); % KITTI00 is usually in z: [0, 4]
end



%% Comparison btn two scan contexts

KITTI_bin1a_path = [data_dir, '000094.bin'];
KITTI_bin1b_path = [data_dir, '000095.bin']; 
KITTI_bin2a_path = [data_dir, '000198.bin'];
KITTI_bin2b_path = [data_dir, '000199.bin'];

ptcloud_KITTI1a = KITTIbin2Ptcloud(KITTI_bin1a_path);
ptcloud_KITTI1b = KITTIbin2Ptcloud(KITTI_bin1b_path);
ptcloud_KITTI2a = KITTIbin2Ptcloud(KITTI_bin2a_path);
ptcloud_KITTI2b = KITTIbin2Ptcloud(KITTI_bin2b_path);

sc_KITTI1a =  Ptcloud2ScanContext(ptcloud_KITTI1a, basic_num_sectors, basic_num_rings, basic_max_range);
sc_KITTI1b =  Ptcloud2ScanContext(ptcloud_KITTI1b, basic_num_sectors, basic_num_rings, basic_max_range);
sc_KITTI2a =  Ptcloud2ScanContext(ptcloud_KITTI2a, basic_num_sectors, basic_num_rings, basic_max_range);
sc_KITTI2b =  Ptcloud2ScanContext(ptcloud_KITTI2b, basic_num_sectors, basic_num_rings, basic_max_range);

dist_1a_1b = DistanceBtnScanContexts(sc_KITTI1a, sc_KITTI1b);
dist_1b_2a = DistanceBtnScanContexts(sc_KITTI1b, sc_KITTI2a);
dist_1a_2a = DistanceBtnScanContexts(sc_KITTI1a, sc_KITTI2a);
dist_2a_2b = DistanceBtnScanContexts(sc_KITTI2a, sc_KITTI2b);

disp([dist_1a_1b, dist_1b_2a, dist_1a_2a, dist_2a_2b]);



