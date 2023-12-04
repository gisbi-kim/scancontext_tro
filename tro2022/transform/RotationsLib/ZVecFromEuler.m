% ZVecFromEuler.m - Philipp Allgeuer - 20/10/16
% Converts a ZYX Euler angles rotation to the corresponding z-vector.
%
% function [ZVec] = ZVecFromEuler(Euler)
%
% Euler ==> Input ZYX Euler angles rotation
% ZVec  ==> Corresponding z-vector

% Main function
function [ZVec] = ZVecFromEuler(Euler)

	% Precalculate the sin and cos values
	cth  = cos(Euler(2));
	sth  = sin(Euler(2));
	cphi = cos(Euler(3));
	sphi = sin(Euler(3));

	% Calculate the required z-vector
	ZVec = [-sth cth*sphi cth*cphi];

end
% EOF