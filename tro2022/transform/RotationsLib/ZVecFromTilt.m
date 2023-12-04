% ZVecFromTilt.m - Philipp Allgeuer - 20/10/16
% Converts a tilt angles rotation to the corresponding z-vector.
%
% function [ZVec] = ZVecFromTilt(Tilt)
%
% Tilt ==> Input tilt angles rotation
% ZVec ==> Corresponding z-vector

% Main function
function [ZVec] = ZVecFromTilt(Tilt)

	% Precalculate the required trigonometric terms
	cgam = cos(Tilt(2));
	sgam = sin(Tilt(2));
	calpha = cos(Tilt(3));
	salpha = sin(Tilt(3));

	% Calculate the required z-vector
	ZVec = [-salpha*sgam salpha*cgam calpha];

end
% EOF