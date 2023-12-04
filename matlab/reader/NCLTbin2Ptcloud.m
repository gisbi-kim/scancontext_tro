function Ptcloud = NCLTbin2Ptcloud(BinPath)
   
%% Hardware Constants
SCALING = 0.005; % 5mm
OFFSET = -100.0;

%% Reading
fidBin = fopen(BinPath, 'r');
    XYZ_Raw = fread(fidBin, 'uint16');
    XYZ_Scaled = XYZ_Raw*SCALING + OFFSET;
fclose(fidBin);

XYZ = reshape(XYZ_Scaled, 4, []);
XYZ = transpose(XYZ(1:3, :));
X = XYZ(:, 1);
Y = XYZ(:, 2);
Z = -1.*XYZ(:, 3);
XYZ = [X, Y, Z];

Ptcloud = pointCloud(XYZ); 

end % end of function
