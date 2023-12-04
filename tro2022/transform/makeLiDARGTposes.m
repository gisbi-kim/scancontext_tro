
poses_cam = readmatrix("08_gt_cam.txt");

cam2lidar_se3 = [
    -1.857739385241e-03 -9.999659513510e-01 -8.039975204516e-03  -4.784029760483e-03 
    -6.481465826011e-03 8.051860151134e-03 -9.999466081774e-01   -7.337429464231e-02 
    9.999773098287e-01 -1.805528627661e-03 -6.496203536139e-03   -3.339968064433e-01
    0 0 0 1;
];

lidar2cam_se3 = inv(cam2lidar_se3);

%%
lidar_init_pose = eye(4);

poses_lidar = reshape(lidar_init_pose, 1, 16); 

lidar_prev = lidar_init_pose;

for ii = 2:length(poses_cam)
    
    cam_curr = [reshape(poses_cam(ii, :), 4, 3)'; 0,0,0,1];
    cam_prev = [reshape(poses_cam(ii-1, :), 4, 3)'; 0,0,0,1];
    
    rel_cam2cam = inv(cam_prev) * cam_curr;
    
    rel_lidar2lidar = lidar2cam_se3 * rel_cam2cam * cam2lidar_se3;
    lidar_curr = lidar_prev * rel_lidar2lidar;
    
    poses_lidar = [poses_lidar; reshape(lidar_curr', 1, 16)];

    lidar_prev = lidar_curr;
end

poses_lidar = poses_lidar(:, 1:12);

%%

times = readmatrix("times.txt");
times = times*10e8;
times = uint64(times);

fid = fopen( 'poses.csv', 'w' );

for jj = 1 : length( times )
    fprintf( fid, '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d \n', ...
        times(jj), ...
        poses_lidar(jj, 1), poses_lidar(jj, 2), poses_lidar(jj, 3), poses_lidar(jj, 4), ...
        poses_lidar(jj, 5), poses_lidar(jj, 6), poses_lidar(jj, 7), poses_lidar(jj, 8), ...
        poses_lidar(jj, 9), poses_lidar(jj, 10), poses_lidar(jj, 11), poses_lidar(jj, 12) ...
    );
end
fclose( fid );



%%
poses_lidar_xyz = poses_lidar(:, [4, 8, 12]);

figure(1); clf;
pcshow(poses_lidar_xyz);

