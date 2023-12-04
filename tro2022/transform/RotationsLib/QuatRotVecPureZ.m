% QuatRotVecPureZ.m - Philipp Allgeuer - 20/03/17
% Rotate a pure z vector by a given quaternion rotation.
%
% function [Vout] = QuatRotVecPureZ(Quat, Vinz)
%
% Quat ==> Quaternion rotation to apply to Vin (assumed to have unit norm)
% Vinz ==> Z component of the input vector to rotate i.e. [0 0 Vinz]
% Vout ==> Rotated output vector (column vector)
%
% This function is an optimisation of QuatRotVec(Quat, [0; 0; Vinz]).

% Main function
function [Vout] = QuatRotVecPureZ(Quat, Vinz)

	% Data aliases
	w = Quat(1);
	x = Quat(2);
	y = Quat(3);
	z = Quat(4);

	% Calculate the output vector
	Vout = Vinz*[2*(x*z+y*w); 2*(y*z-x*w); 1-2*(x*x+y*y)];

end
% EOF