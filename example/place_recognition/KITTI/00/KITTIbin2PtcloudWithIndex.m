function ptcloud = KITTIbin2PtcloudWithIndex(base_dir, index)
   
%% File path 
if( length(num2str(index)) == 4 )
    bin_path = strcat(base_dir, '00', num2str(index), '.bin');
elseif (length(num2str(index)) == 3)
    bin_path = strcat(base_dir, '000', num2str(index), '.bin');
elseif (length(num2str(index)) == 2)
    bin_path = strcat(base_dir, '0000', num2str(index), '.bin');
elseif (length(num2str(index)) == 1)
    bin_path = strcat(base_dir, '00000', num2str(index), '.bin');
end

%% Read 
fid = fopen(bin_path, 'rb'); raw_data = fread(fid, [4 inf], 'single'); fclose(fid);
points = raw_data(1:3,:)'; 
points(:, 3) = points(:, 3) + 1.9; % z in car coord.

ptcloud = pointCloud(points);

end % end of function
