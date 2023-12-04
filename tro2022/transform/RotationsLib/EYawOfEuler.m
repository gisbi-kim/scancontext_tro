% EYawOfEuler.m - Philipp Allgeuer - 05/11/14
% Calculates the ZYX yaw of a ZYX Euler angles rotation.
%
% function [EYaw] = EYawOfEuler(Euler)
%
% Euler ==> Input ZYX Euler angles rotation
% EYaw  ==> ZYX yaw of the input rotation

% Main function
function [EYaw] = EYawOfEuler(Euler)

	% Retrieve the ZYX yaw of the rotation
	EYaw = Euler(1);

end
% EOF