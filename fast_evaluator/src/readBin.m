function ptcloud = readBin(bin_path)
   
%% Read 
fid = fopen(bin_path, 'rb'); raw_data = fread(fid, [4 inf], 'single'); fclose(fid);
points = raw_data(1:3,:)'; 
points(:, 3) = points(:, 3) + 1.9; % z in car coord.

ptcloud = pointCloud(points);

end % end of function
