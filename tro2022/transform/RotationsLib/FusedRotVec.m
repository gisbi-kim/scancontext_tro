% FusedRotVec.m - Philipp Allgeuer - 05/11/14
% Rotate a vector by a given fused angles rotation.
%
% function [Vout] = FusedRotVec(Fused, Vin)
%
% Fused ==> Fused angles rotation to apply to Vin
% Vin   ==> Input vector to rotate
% Vout  ==> Rotated output vector

% Main function
function [Vout] = FusedRotVec(Fused, Vin)

	% Rotate the vector as required
	Vout = zeros(size(Vin));
	Vout(:) = RotmatFromFused(Fused) * Vin(:);

end
% EOF