% LoadRotationsTest.m - Philipp Allgeuer - 05/11/14
% Add the Rotations Library and corresponding test directory to the working path.
%
% If the current directory is the rotations library directory then simply
% execute this script using 'LoadRotationsTest' and change to whatever other
% working directory you wish to have. If not, run the script using:
% >> run path/to/LoadRotationsTest.m
% After this the library and test functions will be available on the path.

% Display a header
disp('');
disp('Loading Rotations Library and Test v1.4.0...');

% Add the path of this script and the Test subdirectory thereof to the working path
ScriptPath = [pwd '/LoadRotationsTest.m'];
TestPath = [pwd '/Test'];
if exist(ScriptPath,'file') ~= 2
	disp('Error: Could not find the path to the LoadRotationsTest.m script');
	disp('Note:  This script is intended for execution using the run command');
	disp('       when LoadRotationsTest.m is not on the current path, or just');
	disp('       normally when this script is in the current working directory.');
	disp('Nothing was changed.');
elseif exist(TestPath,'dir') ~= 7
	disp(['Error: Test folder not found at ' TestPath]);
	disp('Nothing was changed.');
else
	disp(['Adding path: ' pwd]);
	addpath(pwd);
	disp(['Adding path: ' TestPath]);
	addpath(TestPath);
	disp('Done.');
end
disp('');
% EOF