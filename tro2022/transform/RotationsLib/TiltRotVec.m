% TiltRotVec.m - Philipp Allgeuer - 05/11/14
% Rotate a vector by a given tilt angles rotation.
%
% function [Vout] = TiltRotVec(Tilt, Vin)
%
% Tilt ==> Tilt angles rotation to apply to Vin
% Vin  ==> Input vector to rotate
% Vout ==> Rotated output vector

% Main function
function [Vout] = TiltRotVec(Tilt, Vin)

	% Rotate the vector as required
	Vout = zeros(size(Vin));
	Vout(:) = RotmatFromTilt(Tilt) * Vin(:);

end
% EOF