% EYawOfTilt.m - Philipp Allgeuer - 05/11/14
% Calculates the ZYX yaw of a tilt angles rotation.
%
% function [EYaw] = EYawOfTilt(Tilt)
%
% Tilt ==> Input tilt angles rotation
% EYaw ==> ZYX yaw of the input rotation

% Main function
function [EYaw] = EYawOfTilt(Tilt)

	% Precalculate trigonometric terms involved in the rotation matrix expression
	psigam = Tilt(1) + Tilt(2);
	cpsigam = cos(psigam);
	spsigam = sin(psigam);
	cgam = cos(Tilt(2));
	sgam = sin(Tilt(2));
	calpha = cos(Tilt(3));
	A = sgam*calpha;

	% Calculate the ZYX yaw
	EYaw = atan2(cgam*spsigam-A*cpsigam, cgam*cpsigam+A*spsigam);

end
% EOF