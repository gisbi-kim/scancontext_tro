function [ PlaceIndexAndGridCenters ] = makeGridCellIndex ( xRange, yRange, PlaceCellSize )

xSize = xRange(2) - xRange(1);
ySize = yRange(2) - yRange(1);

nGridX = round(xSize/PlaceCellSize);
nGridY = round(ySize/PlaceCellSize);

xGridBoundaries = linspace(xRange(1), xRange(2), nGridX+1); 
yGridBoundaries = linspace(yRange(1), yRange(2), nGridY+1);

nTotalIndex = nGridX * nGridY;

curAssignedIndex = 1; 
PlaceIndexAndGridCenters = zeros(nTotalIndex, 3);
for ii=1:nGridX
    xGridCenter = (xGridBoundaries(ii+1) + xGridBoundaries(ii))/2;
    for jj=1:nGridY
        yGridCenter = (yGridBoundaries(jj+1) + yGridBoundaries(jj))/2;
    
        PlaceIndexAndGridCenters(curAssignedIndex, :) = [curAssignedIndex, xGridCenter, yGridCenter];
        curAssignedIndex = curAssignedIndex + 1;
    end
    
end

end

