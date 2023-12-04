% FYawOfQuat.m - Philipp Allgeuer - 05/11/14
% Calculates the fused yaw of a quaternion rotation.
%
% function [FYaw] = FYawOfQuat(Quat)
%
% Quat ==> Input quaternion rotation (assumed to have unit norm)
% FYaw ==> Fused yaw of the input rotation

% Main function
function [FYaw] = FYawOfQuat(Quat)

	% Calculate the fused yaw of the rotation
	FYaw = 2.0*atan2(Quat(4),Quat(1));
	FYaw = wrap(FYaw);

end
% EOF