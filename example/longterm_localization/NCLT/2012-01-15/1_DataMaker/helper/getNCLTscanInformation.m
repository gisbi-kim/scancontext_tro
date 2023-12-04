function [ ScanTimes ] = getNCLTscanInformation( Scans )

nScans = length(Scans);

TIME_LENGTH = 16; % Dont Change this 
ScanTimes = zeros(nScans, 1);
for i=1:nScans
    ithScanName = Scans{i};
    ithScanTime = str2double(ithScanName(1:TIME_LENGTH));
    ScanTimes(i) = ithScanTime;
end


end

