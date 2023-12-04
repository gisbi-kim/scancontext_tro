function [ PlaceIdx ] = getPlaceIdx(curPose, PlaceIndexAndGridCenters)

%% load meta file 

%% Main
curX = curPose(1);
curY = curPose(2);

PlaceCellCenters = PlaceIndexAndGridCenters(:, 2:3);
nPlaces = length(PlaceCellCenters);

Dists = zeros(nPlaces, 1);
for ii=1:nPlaces
    Dist = norm(PlaceCellCenters(ii, :) - [curX, curY]);
    Dists(ii) = Dist;
end

[NearestDist, NearestIdx] = min(Dists);

PlaceIdx = NearestIdx;

end

