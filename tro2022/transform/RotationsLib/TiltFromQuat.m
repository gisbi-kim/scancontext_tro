% TiltFromQuat.m - Philipp Allgeuer - 05/11/14
% Converts a quaternion rotation to the corresponding tilt angles representation.
%
% function [Tilt] = TiltFromQuat(Quat)
%
% The output ranges are:
% Fused yaw:        psi   is in (-pi,pi]
% Tilt axis angle:  gamma is in (-pi,pi]
% Tilt angle:       alpha is in [0,pi]
% 
% Quat ==> Input quaternion rotation (assumed to have unit norm)
% Tilt ==> Equivalent tilt angles rotation

% Main function
function [Tilt] = TiltFromQuat(Quat)

	% Calculate the fused yaw
	psi = 2.0*atan2(Quat(4),Quat(1));
	psi = wrap(psi);

	% Calculate the tilt axis angle
	gamma = atan2(Quat(1)*Quat(3)-Quat(2)*Quat(4),Quat(1)*Quat(2)+Quat(3)*Quat(4));

	% Calculate the tilt angle
	calpha = max(min(2*(Quat(1)*Quat(1)+Quat(4)*Quat(4))-1,1.0),-1.0); % Note: If Quat is valid then this should only trim at most a few eps...
	alpha = acos(calpha);

	% Return the tilt angles representation
	Tilt = [psi gamma alpha];

end
% EOF