% FusedNoEYaw.m - Philipp Allgeuer - 05/11/14
% Removes the ZYX yaw component of a fused angles rotation.
%
% function [Fout, EYaw, FEYaw] = FusedNoEYaw(Fin)
%
% Fin   ==> Input fused angles rotation
% Fout  ==> Output fused angles rotation with no ZYX yaw
% EYaw  ==> ZYX yaw of the input rotation
% FEYaw ==> Fused angles representation of the ZYX yaw component
%           of the input rotation

% Main function
function [Fout, EYaw, FEYaw] = FusedNoEYaw(Fin)

	% Calculate the ZYX yaw of the input
	EYaw = EYawOfFused(Fin);

	% Construct the ZYX yaw component of the rotation
	FEYaw = [EYaw 0 0 1];

	% Remove the ZYX yaw component of the rotation
	Fout = [Fin(1)-EYaw Fin(2:4)];

end
% EOF