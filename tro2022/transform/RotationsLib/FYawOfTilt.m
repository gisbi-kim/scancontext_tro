% FYawOfTilt.m - Philipp Allgeuer - 05/11/14
% Calculates the fused yaw of a tilt angles rotation.
%
% function [FYaw] = FYawOfTilt(Tilt)
%
% Tilt ==> Input tilt angles rotation
% FYaw ==> Fused yaw of the input rotation

% Main function
function [FYaw] = FYawOfTilt(Tilt)

	% Retrieve the fused yaw of the rotation
	FYaw = Tilt(1);

end
% EOF