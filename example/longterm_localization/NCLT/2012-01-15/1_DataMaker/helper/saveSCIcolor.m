function [ ] = saveSCIcolor(curSCIcolor, DIR_SCIcolor, SamplingCounter, PlaceIdx, CellSize, ForB)

SCIcolor = curSCIcolor;

curSamplingCounter = num2str(SamplingCounter,'%0#6.f');
curSamplingCounter = curSamplingCounter(1:end-1);

curPlaceIdx = num2str(PlaceIdx,'%0#6.f');
curPlaceIdx = curPlaceIdx(1:end-1);     

saveName = strcat(curSamplingCounter, '_', curPlaceIdx);
saveDir = strcat(DIR_SCIcolor, CellSize, '/');
if( ~exist(saveDir))
    mkdir(saveDir)
end

savePath = strcat(saveDir, saveName, ForB, '.png');

imwrite(SCIcolor, savePath);

end

