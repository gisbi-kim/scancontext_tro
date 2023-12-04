function [ Ptcloud ] = getNearestPtcloud( ScanTimes, curTime, Scans, ScanDir)

[MinTimeDelta, ArgminIdx] = min(abs(ScanTimes-curTime));
ArgminBinName = Scans{ArgminIdx};
ArgminBinPath = strcat(ScanDir, ArgminBinName);
Ptcloud = NCLTbin2Ptcloud(ArgminBinPath);

end

