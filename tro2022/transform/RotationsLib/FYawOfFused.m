% FYawOfFused.m - Philipp Allgeuer - 05/11/14
% Calculates the fused yaw of a fused angles rotation.
%
% function [FYaw] = FYawOfFused(Fused)
%
% Fused ==> Input fused angles rotation
% FYaw  ==> Fused yaw of the input rotation

% Main function
function [FYaw] = FYawOfFused(Fused)

	% Retrieve the fused yaw of the rotation
	FYaw = Fused(1);

end
% EOF