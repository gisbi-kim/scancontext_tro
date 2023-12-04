% EulerRotVec.m - Philipp Allgeuer - 05/11/14
% Rotate a vector by a given ZYX Euler angles rotation.
%
% function [Vout] = EulerRotVec(Euler, Vin)
%
% Euler ==> ZYX Euler angles rotation to apply to Vin
% Vin   ==> Input vector to rotate
% Vout  ==> Rotated output vector

% Main function
function [Vout] = EulerRotVec(Euler, Vin)

	% Rotate the vector as required
	Vout = zeros(size(Vin));
	Vout(:) = RotmatFromEuler(Euler) * Vin(:);

end
% EOF