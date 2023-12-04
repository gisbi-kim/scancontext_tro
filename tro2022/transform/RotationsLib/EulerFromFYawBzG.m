% EulerFromFYawBzG - Philipp Allgeuer - 20/10/16
% Calculates the ZYX Euler angles (EGB) with a given fused yaw and global z-axis in body-fixed coordinates (BzG).
%
% function [EGB] = EulerFromFYawBzG(FYaw, BzG)
%
% It is assumed that BzG is a unit vector!

% Main function
function [EGB] = EulerFromFYawBzG(FYaw, BzG)

	% Calculate the Euler pitch
	stheta = max(min(-BzG(1),1.0),-1.0); % Note: If BzG is a unit vector then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the Euler roll
	phi = atan2(BzG(2),BzG(3));

	% Calculate the ZYX yaw
	if stheta == 0 && BzG(2) == 0
		EYaw = FYaw;
	else
		cphi = cos(phi);
		sphi = sin(phi);
		EYaw = FYaw + atan2(sphi,stheta*cphi) - atan2(BzG(2),stheta);
	end
	EYaw = wrap(EYaw);

	% Construct the output Euler angles
	EGB = [EYaw theta phi];

end
% EOF