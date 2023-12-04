% RotmatNoEYaw.m - Philipp Allgeuer - 05/11/14
% Removes the ZYX yaw component of a rotation matrix.
%
% function [Rout, EYaw, REYaw] = RotmatNoEYaw(Rin)
%
% Rin   ==> Input rotation matrix
% Rout  ==> Output rotation matrix with no ZYX yaw
% EYaw  ==> ZYX yaw of the input rotation
% REYaw ==> Rotation matrix representation of the ZYX yaw component
%           of the input rotation

% Main function
function [Rout, EYaw, REYaw] = RotmatNoEYaw(Rin)

	% Calculate the ZYX yaw of the input
	EYaw = atan2(Rin(2,1),Rin(1,1));

	% Construct the ZYX yaw component of the rotation
	cEYaw = cos(EYaw);
	sEYaw = sin(EYaw);
	REYaw = [cEYaw -sEYaw 0;sEYaw cEYaw 0;0 0 1];

	% Remove the ZYX yaw component of the rotation
	Rout = REYaw' * Rin;

end
% EOF