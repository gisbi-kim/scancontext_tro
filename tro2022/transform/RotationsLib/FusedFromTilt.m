% FusedFromTilt.m - Philipp Allgeuer - 05/11/14
% Converts a tilt angles rotation to the corresponding fused angles representation.
%
% function [Fused] = FusedFromTilt(Tilt)
%
% The output ranges are:
% Fused yaw:   psi   is in (-pi,pi]
% Fused pitch: theta is in [-pi/2,pi/2]
% Fused roll:  phi   is in [-pi/2,pi/2]
% Hemisphere:  h     is in {-1,1}
% 
% Tilt  ==> Input tilt angles rotation
% Fused ==> Equivalent fused angles rotation

% Main function
function [Fused] = FusedFromTilt(Tilt)
	
	% Get the required value of pi
	PI = GetPI(Tilt);

	% Precalculate sin and cos values
	cgamma = cos(Tilt(2));
	sgamma = sin(Tilt(2));
	salpha = sin(Tilt(3));

	% Calculate theta and phi
	theta = asin(salpha*sgamma);
	phi   = asin(salpha*cgamma);

	% See which hemisphere we're in
	if abs(Tilt(3)) <= PI/2
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	Fused = [Tilt(1) theta phi h];

end
% EOF