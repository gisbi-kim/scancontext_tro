% RotmatFromEuler.m - Philipp Allgeuer - 05/11/14
% Converts a ZYX Euler angles rotation to the corresponding rotation matrix representation.
%
% function [Rotmat] = RotmatFromEuler(Euler)
%
% The output of this function is a 3x3 matrix that to machine precision is orthogonal.
% Note however, that it cannot be assumed that every element of Rotmat is strictly and
% irrefutably in the range [-1,1]. It is possible that values such as 1+k*eps come out,
% and so care should be taken when applying (for instance) inverse trigonometric functions
% (e.g. asin, acos) to the rotation matrix elements, as otherwise complex values may result. 
%
% Euler  ==> Input ZYX Euler angles rotation
% Rotmat ==> Equivalent rotation matrix

% Main function
function [Rotmat] = RotmatFromEuler(Euler)

	% Precalculate the sin and cos values
	cpsi = cos(Euler(1));
	cth  = cos(Euler(2));
	cphi = cos(Euler(3));
	spsi = sin(Euler(1));
	sth  = sin(Euler(2));
	sphi = sin(Euler(3));

	% Calculate the required rotation matrix
	Rotmat = [cpsi*cth cpsi*sth*sphi-spsi*cphi cpsi*sth*cphi+spsi*sphi;
	          spsi*cth spsi*sth*sphi+cpsi*cphi spsi*sth*cphi-cpsi*sphi;
	          -sth     cth*sphi                cth*cphi];

end
% EOF