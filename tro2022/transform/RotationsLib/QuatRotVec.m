% QuatRotVec.m - Philipp Allgeuer - 05/11/14
% Rotate a vector by a given quaternion rotation.
%
% function [Vout] = QuatRotVec(Quat, Vin)
%
% Quat ==> Quaternion rotation to apply to Vin (assumed to have unit norm)
% Vin  ==> Input vector to rotate
% Vout ==> Rotated output vector

% Main function
function [Vout] = QuatRotVec(Quat, Vin)

	% Rotate the vector as required
	Vout = zeros(size(Vin));
	Vin = Vin(:)';
	Vout(:) = (Quat(1)*Quat(1) - Quat(2)*Quat(2) - Quat(3)*Quat(3) - Quat(4)*Quat(4))*Vin + 2*dot(Quat(2:4),Vin)*Quat(2:4) + 2*Quat(1)*cross(Quat(2:4),Vin);

end
% EOF