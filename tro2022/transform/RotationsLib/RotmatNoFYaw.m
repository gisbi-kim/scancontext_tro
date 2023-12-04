% RotmatNoFYaw.m - Philipp Allgeuer - 05/11/14
% Removes the fused yaw component of a rotation matrix.
%
% function [Rout, FYaw, RFYaw] = RotmatNoFYaw(Rin)
%
% Rin   ==> Input rotation matrix
% Rout  ==> Output rotation matrix with zero fused yaw
% FYaw  ==> Fused yaw of the input rotation
% RFYaw ==> Rotation matrix representation of the fused yaw component
%           of the input rotation

% Main function
function [Rout, FYaw, RFYaw] = RotmatNoFYaw(Rin)

	% Calculate the fused yaw of the input
	FYaw = FYawOfRotmat(Rin);

	% Construct the fused yaw component of the rotation
	cFYaw = cos(FYaw);
	sFYaw = sin(FYaw);
	RFYaw = [cFYaw -sFYaw 0;sFYaw cFYaw 0;0 0 1];

	% Remove the fused yaw component of the rotation
	Rout = RFYaw' * Rin;

end
% EOF