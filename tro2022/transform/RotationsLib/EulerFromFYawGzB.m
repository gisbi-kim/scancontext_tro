% EulerFromFYawGzB - Philipp Allgeuer - 26/10/16
% Calculates the ZYX Euler angles (EGB) with a given fused yaw and body-fixed z-axis in global coordinates (GzB).
%
% function [EGB] = EulerFromFYawGzB(FYaw, GzB)
%
% It is assumed that GzB is a unit vector!

% Main function
function [EGB] = EulerFromFYawGzB(FYaw, GzB)

	% Precalculate trigonometric terms
	cfyaw = cos(FYaw);
	sfyaw = sin(FYaw);

	% Calculate the Euler pitch
	stheta = cfyaw*GzB(1) + sfyaw*GzB(2);
	stheta = max(min(stheta,1.0),-1.0); % Note: If GzB is a unit vector then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the Euler roll
	sfphi = sfyaw*GzB(1) - cfyaw*GzB(2);
	phi = atan2(sfphi, GzB(3));

	% Calculate the ZYX yaw
	if stheta == 0 && sfphi == 0
		EYaw = FYaw;
	else
		cphi = cos(phi);
		sphi = sin(phi);
		EYaw = FYaw + atan2(sphi,stheta*cphi) - atan2(sfphi,stheta);
	end
	EYaw = wrap(EYaw);

	% Construct the output Euler angles
	EGB = [EYaw theta phi];

end
% EOF