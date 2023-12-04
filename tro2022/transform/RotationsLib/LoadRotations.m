% LoadRotations.m - Philipp Allgeuer - 05/11/14
% Add the Rotations Library directory to the working path.
%
% If the current directory is the rotations library directory then simply
% execute this script using 'LoadRotations' and change to whatever other
% working directory you wish to have. If not, run the script using:
% >> run path/to/LoadRotations.m
% After this the library functions will be available on the path.

% Display a header
disp('');
disp('Loading Rotations Library v1.4.0...');

% Add the path of this script to the working path
ScriptPath = [pwd '/LoadRotations.m'];
if exist(ScriptPath,'file') ~= 2
	disp('Error: Could not find the path to the LoadRotations.m script');
	disp('Note:  This script is intended for execution using the run command');
	disp('       when LoadRotations.m is not on the current path, or just');
	disp('       normally when this script is in the current working directory.');
	disp('Nothing was changed.');
else
	disp(['Adding path: ' pwd]);
	addpath(pwd);
	disp('Done.');
end
disp('');
% EOF