% EulerFromTilt.m - Philipp Allgeuer - 05/11/14
% Converts a tilt angles rotation to the corresponding ZYX Euler angles representation.
%
% function [Euler] = EulerFromTilt(Tilt)
%
% The output ranges are:
% Yaw:   psi   is in (-pi,pi]
% Pitch: theta is in [-pi/2,pi/2]
% Roll:  phi   is in (-pi,pi]
%
% Tilt  ==> Input tilt angles rotation
% Euler ==> Equivalent ZYX Euler angles rotation

% Main function
function [Euler] = EulerFromTilt(Tilt)

	% Precalculate the required trigonometric terms
	cgam = cos(Tilt(2));
	sgam = sin(Tilt(2));
	calpha = cos(Tilt(3));
	salpha = sin(Tilt(3));
	psigam = Tilt(1) + Tilt(2);
	cpsigam = cos(psigam);
	spsigam = sin(psigam);

	% Precalculate additional required terms
	sphi = cgam*salpha;
	stheta = sgam*salpha; % No need to manually coerce to [-1,1] due to construction
	A = sgam*calpha;

	% Calculate the required Euler angles representation
	Euler = [atan2(cgam*spsigam-A*cpsigam,cgam*cpsigam+A*spsigam) asin(stheta) atan2(sphi,calpha)];

end
% EOF