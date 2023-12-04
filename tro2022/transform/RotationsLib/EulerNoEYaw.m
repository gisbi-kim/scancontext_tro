% EulerNoEYaw.m - Philipp Allgeuer - 05/11/14
% Removes the ZYX yaw component of a ZYX Euler angles rotation.
%
% function [Eout, EYaw, EEYaw] = EulerNoEYaw(Ein)
%
% Ein   ==> Input ZYX Euler angles rotation
% Eout  ==> Output ZYX Euler angles rotation with no ZYX yaw
% EYaw  ==> ZYX yaw of the input rotation
% EEYaw ==> ZYX Euler angles representation of the ZYX yaw component
%           of the input rotation

% Main function
function [Eout, EYaw, EEYaw] = EulerNoEYaw(Ein)

	% Calculate the ZYX yaw of the input
	EYaw = Ein(1);

	% Construct the ZYX yaw component of the rotation
	EEYaw = [EYaw 0 0];

	% Remove the ZYX yaw component of the rotation
	Eout = [0 Ein(2:3)];

end
% EOF