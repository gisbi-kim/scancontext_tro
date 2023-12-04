% RotmatFromTilt.m - Philipp Allgeuer - 05/11/14
% Converts a tilt angles rotation to the corresponding rotation matrix representation.
%
% function [Rotmat] = RotmatFromTilt(Tilt)
%
% The output of this function is a 3x3 matrix that to machine precision is orthogonal.
% Note however, that it cannot be assumed that every element of Rotmat is strictly and
% irrefutably in the range [-1,1]. It is possible that values such as 1+k*eps come out,
% and so care should be taken when applying (for instance) inverse trigonometric functions
% (e.g. asin, acos) to the rotation matrix elements, as otherwise complex values may result. 
%
% Tilt   ==> Input tilt angles rotation
% Rotmat ==> Equivalent rotation matrix

% Main function
function [Rotmat] = RotmatFromTilt(Tilt)

	% Precalculate the required trigonometric terms
	cgam = cos(Tilt(2));
	sgam = sin(Tilt(2));
	calpha = cos(Tilt(3));
	salpha = sin(Tilt(3));
	psigam = Tilt(1) + Tilt(2);
	cpsigam = cos(psigam);
	spsigam = sin(psigam);

	% Precalculate additional terms involved in the rotation matrix expression
	A = cgam * cpsigam;
	B = sgam * cpsigam;
	C = cgam * spsigam;
	D = sgam * spsigam;

	% Calculate the required rotation matrix
	Rotmat = [ A+D*calpha  B-C*calpha   salpha*spsigam;
	           C-B*calpha  D+A*calpha  -salpha*cpsigam;
	          -salpha*sgam salpha*cgam  calpha       ];

end
% EOF