% TiltNoFYaw.m - Philipp Allgeuer - 05/11/14
% Removes the fused yaw component of a tilt angles rotation.
%
% function [Tout, FYaw, TFYaw] = TiltNoFYaw(Tin)
%
% Tin   ==> Input tilt angles rotation
% Tout  ==> Output tilt angles rotation with zero fused yaw
% FYaw  ==> Fused yaw of the input rotation
% TFYaw ==> Tilt angles representation of the fused yaw component
%           of the input rotation

% Main function
function [Tout, FYaw, TFYaw] = TiltNoFYaw(Tin)

	% Calculate the fused yaw of the input
	FYaw = Tin(1);

	% Construct the fused yaw component of the rotation
	TFYaw = [FYaw 0 0];

	% Remove the fused yaw component of the rotation
	Tout = [0 Tin(2:3)];

end
% EOF