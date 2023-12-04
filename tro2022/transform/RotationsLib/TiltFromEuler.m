% TiltFromEuler.m - Philipp Allgeuer - 05/11/14
% Converts a ZYX Euler angles rotation to the corresponding tilt angles representation.
%
% function [Tilt, Rotmat] = TiltFromEuler(Euler)
%
% The output ranges are:
% Fused yaw:        psi   is in (-pi,pi]
% Tilt axis angle:  gamma is in (-pi,pi]
% Tilt angle:       alpha is in [0,pi]
% 
% Euler  ==> Input ZYX Euler angles rotation
% Tilt   ==> Equivalent tilt angles rotation
% Rotmat ==> Equivalent rotation matrix

% Main function
function [Tilt, Rotmat] = TiltFromEuler(Euler)

	% Calculation of the fused yaw in a numerically stable manner requires the complete rotation matrix representation
	Rotmat = RotmatFromEuler(Euler);

	% Calculate the fused yaw
	psi = FYawOfRotmat(Rotmat);

	% Calculate the tilt axis angle
	gamma = atan2(-Rotmat(3,1),Rotmat(3,2));

	% Calculate the tilt angle
	calpha = max(min(Rotmat(3,3),1.0),-1.0); % Note: If Rotmat is valid then this should only trim at most a few eps...
	alpha = acos(calpha);

	% Return the tilt angles representation
	Tilt = [psi gamma alpha];

end
% EOF