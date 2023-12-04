% TiltNoEYaw.m - Philipp Allgeuer - 05/11/14
% Removes the ZYX yaw component of a tilt angles rotation.
%
% function [Tout, EYaw, TEYaw] = TiltNoEYaw(Tin)
%
% Tin   ==> Input tilt angles rotation
% Tout  ==> Output tilt angles rotation with no ZYX yaw
% EYaw  ==> ZYX yaw of the input rotation
% TEYaw ==> Tilt angles representation of the ZYX yaw component
%           of the input rotation

% Main function
function [Tout, EYaw, TEYaw] = TiltNoEYaw(Tin)

	% Calculate the ZYX yaw of the input
	EYaw = EYawOfTilt(Tin);

	% Construct the ZYX yaw component of the rotation
	TEYaw = [EYaw 0 0];

	% Remove the ZYX yaw component of the rotation
	Tout = [Tin(1)-EYaw Tin(2:3)];

end
% EOF