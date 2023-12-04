% EYawOfQuat.m - Philipp Allgeuer - 05/11/14
% Calculates the ZYX yaw of a quaternion rotation.
%
% function [EYaw] = EYawOfQuat(Quat)
%
% Quat ==> Input quaternion rotation (assumed to have unit norm)
% EYaw ==> ZYX yaw of the input rotation

% Main function
function [EYaw] = EYawOfQuat(Quat)

	% Calculate the ZYX yaw of the rotation
	EYaw = atan2(2.0*(Quat(1)*Quat(4)+Quat(2)*Quat(3)), 1.0-2.0*(Quat(3)*Quat(3)+Quat(4)*Quat(4)));

end
% EOF