% FusedNoFYaw.m - Philipp Allgeuer - 05/11/14
% Removes the fused yaw component of a fused angles rotation.
%
% function [Fout, FYaw, FFYaw] = FusedNoFYaw(Fin)
%
% Fin   ==> Input fused angles rotation
% Fout  ==> Output fused angles rotation with zero fused yaw
% FYaw  ==> Fused yaw of the input rotation
% FFYaw ==> Fused angles representation of the fused yaw component
%           of the input rotation

% Main function
function [Fout, FYaw, FFYaw] = FusedNoFYaw(Fin)

	% Calculate the fused yaw of the input
	FYaw = Fin(1);

	% Construct the fused yaw component of the rotation
	FFYaw = [FYaw 0 0 1];

	% Remove the fused yaw component of the rotation
	Fout = [0 Fin(2:4)];

end
% EOF