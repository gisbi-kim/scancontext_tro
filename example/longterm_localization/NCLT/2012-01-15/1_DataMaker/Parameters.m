% flag for train/test
IF_TRAINING = 1;

% sampling gap 
SamplingGap = 1; % in meter 

% place resolution 
PlaceCellSize = 10; % in meter 

% NCLT region
xRange = [-350, 130];
yRange = [-730, 120];


% scan context
nRings = 40;
nSectors = 120;
Lmax = 80;

% scan context image 
NCLTminHeight = 0;
NCLTmaxHeight = 15;

SCI_HEIGHT_RANGE = [NCLTminHeight, NCLTmaxHeight];

minColor = 0;
maxColor = 255;
rangeColor = maxColor - minColor;

