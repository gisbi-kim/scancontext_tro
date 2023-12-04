% FusedFromQuat.m - Philipp Allgeuer - 05/11/14
% Converts a quaternion rotation to the corresponding fused angles representation.
%
% function [Fused, Tilt] = FusedFromQuat(Quat)
%
% The output ranges are:
% Fused yaw:   psi   is in (-pi,pi]
% Fused pitch: theta is in [-pi/2,pi/2]
% Fused roll:  phi   is in [-pi/2,pi/2]
% Hemisphere:  h     is in {-1,1}
% 
% Quat  ==> Input quaternion rotation (assumed to have unit norm)
% Fused ==> Equivalent fused angles rotation
% Tilt  ==> Equivalent tilt angles rotation

% Main function
function [Fused, Tilt] = FusedFromQuat(Quat)

	% Calculate the fused yaw
	psi = 2.0*atan2(Quat(4),Quat(1));
	psi = wrap(psi);

	% Calculate the fused pitch
	rawstheta = 2.0*(Quat(3)*Quat(1)-Quat(2)*Quat(4));
	stheta = max(min(rawstheta,1.0),-1.0); % Note: If Quat is valid then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the fused roll
	rawsphi = 2.0*(Quat(3)*Quat(4)+Quat(2)*Quat(1));
	sphi = max(min(rawsphi,1.0),-1.0); % Note: If Quat is valid then this should only trim at most a few eps...
	phi = asin(sphi);

	% See which hemisphere we're in
	zzG = 2.0*(Quat(1)*Quat(1) + Quat(4)*Quat(4)) - 1.0;
	if zzG >= 0
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	Fused = [psi theta phi h];

	% Construct the output tilt angles
	if nargout >= 2
		gamma = atan2(rawstheta,rawsphi);
		calpha = max(min(zzG,1.0),-1.0); % Note: If Quat is valid then this should only trim at most a few eps...
		alpha = acos(calpha);
		Tilt = [psi gamma alpha];
	end

end
% EOF