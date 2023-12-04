% EYawOfRotmat.m - Philipp Allgeuer - 05/11/14
% Calculates the ZYX yaw of a rotation matrix.
%
% function [EYaw] = EYawOfRotmat(Rotmat)
%
% Rotmat ==> Input rotation matrix
% EYaw   ==> ZYX yaw of the input rotation

% Main function
function [EYaw] = EYawOfRotmat(Rotmat)

	% Calculate the ZYX yaw of the rotation
	EYaw = atan2(Rotmat(2,1),Rotmat(1,1));

end
% EOF