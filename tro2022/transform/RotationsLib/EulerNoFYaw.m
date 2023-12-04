% EulerNoFYaw.m - Philipp Allgeuer - 05/11/14
% Removes the fused yaw component of a ZYX Euler angles rotation.
%
% function [Eout, FYaw, EFYaw] = EulerNoFYaw(Ein)
%
% Ein   ==> Input ZYX Euler angles rotation
% Eout  ==> Output ZYX Euler angles rotation with zero fused yaw
% FYaw  ==> Fused yaw of the input rotation
% EFYaw ==> ZYX Euler angles representation of the fused yaw component
%           of the input rotation

% Main function
function [Eout, FYaw, EFYaw] = EulerNoFYaw(Ein)

	% Calculate the fused yaw of the input
	FYaw = FYawOfEuler(Ein);

	% Construct the fused yaw component of the rotation
	EFYaw = [FYaw 0 0];

	% Remove the fused yaw component of the rotation
	Eout = [Ein(1)-FYaw Ein(2:3)];

end
% EOF