% FYawOfEuler.m - Philipp Allgeuer - 05/11/14
% Calculates the fused yaw of a ZYX Euler angles rotation.
%
% function [FYaw, Rotmat] = FYawOfEuler(Euler)
%
% Euler  ==> Input ZYX Euler angles rotation
% FYaw   ==> Fused yaw of the input rotation
% Rotmat ==> Equivalent rotation matrix

% Main function
function [FYaw, Rotmat] = FYawOfEuler(Euler)

	% Calculation of the fused yaw in a numerically stable manner requires the complete rotation matrix representation
	Rotmat = RotmatFromEuler(Euler);

	% Calculate the fused yaw
	FYaw = FYawOfRotmat(Rotmat);

end
% EOF