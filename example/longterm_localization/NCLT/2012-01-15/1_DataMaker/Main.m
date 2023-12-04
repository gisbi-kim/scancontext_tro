%% information 
% main for Sampling places  

%% 
clear; clc;
addpath(genpath('../../../../../matlab/'));
addpath(genpath('./helper'));

SaveDirectoryList
Parameters

%% Preparation 1: make pre-determined Grid Cell index 
PlaceIndexAndGridCenters_10m = makeGridCellIndex(xRange, yRange, 10);

%% Preparation 2: get scan times 
SequenceDate = '2012-01-15'; % ### Change this part to your date
ScanBaseDir = 'F:\NCLT/'; % ### Change this part to your path 

ScanDir = strcat(ScanBaseDir, SequenceDate, '/velodyne_sync/');
Scans = dir(ScanDir); Scans(1:2, :) = []; Scans = {Scans(:).name};
ScanTimes = getNCLTscanInformation(Scans);

%% Preparation 3: load GT pose (for calc moving diff and location)
GroundTruthPosePath = strcat(ScanBaseDir, SequenceDate, '/groundtruth_', SequenceDate, '.csv');
GroundTruthPoseData = csvread(GroundTruthPosePath);

GroundTruthPoseTime = GroundTruthPoseData(:, 1);
GroundTruthPoseXYZ = GroundTruthPoseData(:, 2:4);

nGroundTruthPoses = length(GroundTruthPoseData);

%% logger
TrajectoryInformationWRT10mCell = [];

nTotalSampledPlaces = 0;

%% Main: Sampling 

MoveCounter = 0; % Reset 0 again for every SamplingGap reached.
for ii = 1000:nGroundTruthPoses % just quite large number 1000 for avoiding first several NaNs 
    curTime = GroundTruthPoseTime(ii, 1);

    prvPose = GroundTruthPoseXYZ(ii-1, :);
    curPose = GroundTruthPoseXYZ(ii, :);
    
    curMove = norm(curPose - prvPose);
    MoveCounter = MoveCounter + curMove;
    
    if(MoveCounter >= SamplingGap)
        nTotalSampledPlaces = nTotalSampledPlaces + 1; 
        curSamplingCounter = nTotalSampledPlaces;

        % Returns the index of the cell, where the current pose is closest to the cell's center coordinates.
        PlaceIdx_10m = getPlaceIdx(curPose, PlaceIndexAndGridCenters_10m); % 2nd argument is cell's size 

        % load current point cloud 
        curPtcloud = getNearestPtcloud( ScanTimes, curTime, Scans, ScanDir);

        %% Save data
        % log
        TrajectoryInformationWRT10mCell = [TrajectoryInformationWRT10mCell; curTime, curPose, nTotalSampledPlaces, PlaceIdx_10m];
        
        % scan context
        ScanContextForward = Ptcloud2ScanContext(curPtcloud, nSectors, nRings, Lmax);
        
        % SCI gray (1 channel)
        ScanContextForwardRanged = ScaleSc2Img(ScanContextForward, NCLTminHeight, NCLTmaxHeight);
        ScanContextForwardScaled = ScanContextForwardRanged./maxColor;

        SCIforwardGray = round(ScanContextForwardScaled*255);
        SCIforwardGray = ind2gray(SCIforwardGray, gray(255));
       
        % SCI jet (color, 3 channel) 
        SCIforwardColor = round(ScanContextForwardScaled*255);
        SCIforwardColor = ind2rgb(SCIforwardColor, jet(255));

        saveSCIcolor(SCIforwardColor, DIR_SCIcolor, curSamplingCounter, PlaceIdx_10m, '10', 'f');

        % SCI jet + Backward dataAug 
        ScanContextBackwardScaled = circshift(ScanContextForwardScaled, nSectors/2, 2);
        SCIbackwardColor = round(ScanContextBackwardScaled*255);
        SCIbackwardColor = ind2rgb(SCIbackwardColor, jet(255));

        saveSCIcolor(SCIforwardColor, DIR_SCIcolorAlsoBack, curSamplingCounter, PlaceIdx_10m, '10', 'f');
        saveSCIcolor(SCIbackwardColor, DIR_SCIcolorAlsoBack, curSamplingCounter, PlaceIdx_10m, '10', 'b');
        
        % End: Reset counter 
        MoveCounter = 0;
                
        % Tracking progress message  
        if(rem(curSamplingCounter, 100) == 0)
           message = strcat(num2str(curSamplingCounter), "th sample is saved." );
           disp(message)
        end
        
    end
    
end


%% save Trajectory Information
% 10m
filepath = strcat(DIR_SampledPlacesInformation, '/TrajectoryInformation.csv');
TrajectoryInformation = TrajectoryInformationWRT10mCell;
dlmwrite(filepath, TrajectoryInformation, 'precision','%.6f')







