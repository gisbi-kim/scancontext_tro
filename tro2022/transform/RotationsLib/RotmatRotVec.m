% RotmatRotVec.m - Philipp Allgeuer - 05/11/14
% Rotate a vector by a given rotation matrix.
%
% function [Vout] = RotmatRotVec(Rotmat, Vin)
%
% Rotmat ==> Rotation matrix to apply to Vin
% Vin    ==> Input vector to rotate
% Vout   ==> Rotated output vector

% Main function
function [Vout] = RotmatRotVec(Rotmat, Vin)

	% Rotate the vector as required
	Vout = zeros(size(Vin));
	Vout(:) = Rotmat * Vin(:);

end
% EOF