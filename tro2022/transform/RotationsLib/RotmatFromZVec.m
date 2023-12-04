% RotmatFromZVec.m - Philipp Allgeuer - 21/10/16
% Converts a z-vector to the corresponding zero fused yaw rotation matrix representation.
%
% function [Rotmat, Quat] = RotmatFromZVec(ZVec)
%
% It is assumed that ZVec is a unit vector!
%
% ZVec   ==> Input z-vector
% Rotmat ==> Corresponding zero fused yaw rotation matrix
% Quat   ==> Corresponding zero fused yaw quaternion

% Main function
function [Rotmat, Quat] = RotmatFromZVec(ZVec)

	% Calculate the quaternion representation of the required rotation
	Quat = QuatFromZVec(ZVec);

	% Return the required rotation matrix representation
	Rotmat = RotmatFromQuat(Quat);

end
% EOF