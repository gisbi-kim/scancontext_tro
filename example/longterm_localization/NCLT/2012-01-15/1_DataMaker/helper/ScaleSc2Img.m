function [ scScaled ] = ScaleSc2Img( scOriginal, minHeight, maxHeight )

maxColor = 255;

rangeHeight = maxHeight - minHeight;

nRows = size(scOriginal, 1);
nCols = size(scOriginal, 2);

scOriginalRangeCut = scOriginal;
% cut into range 
for ithRow = 1:nRows
    for jthCol = 1:nCols
        
        ithPixel = scOriginal(ithRow, jthCol);
        
        if(ithPixel >= maxHeight)
            scOriginalRangeCut(ithRow, jthCol) = maxHeight;
        end
        
        if(ithPixel <= minHeight)
            scOriginalRangeCut(ithRow, jthCol) = minHeight;
        end
        
        scOriginalRangeCut(ithRow, jthCol) = round(scOriginalRangeCut(ithRow, jthCol) * (maxColor/rangeHeight));
    end
end

scScaled = scOriginalRangeCut;


end

