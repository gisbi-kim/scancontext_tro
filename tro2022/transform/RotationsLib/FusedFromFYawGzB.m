% FusedFromFYawGzB - Philipp Allgeuer - 26/10/16
% Calculates the fused angles (FGB) with a given fused yaw and body-fixed z-axis in global coordinates (GzB).
%
% function [FGB] = FusedFromFYawGzB(FYaw, GzB)
%
% It is assumed that GzB is a unit vector!

% Main function
function [FGB] = FusedFromFYawGzB(FYaw, GzB)

	% Wrap the fused yaw to the desired range
	FYaw = wrap(FYaw);

	% Precalculate trigonometric terms
	cpsi = cos(FYaw);
	spsi = sin(FYaw);

	% Calculate the fused pitch
	stheta = cpsi*GzB(1) + spsi*GzB(2);
	stheta = max(min(stheta,1.0),-1.0); % Note: If GzB is a unit vector then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the fused roll
	sphi = spsi*GzB(1) - cpsi*GzB(2);
	sphi = max(min(sphi,1.0),-1.0); % Note: If GzB is a unit vector then this should only trim at most a few eps...
	phi = asin(sphi);

	% See which hemisphere we're in
	if GzB(3) >= 0
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	FGB = [FYaw theta phi h];

end
% EOF