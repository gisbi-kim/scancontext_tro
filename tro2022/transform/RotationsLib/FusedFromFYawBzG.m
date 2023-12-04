% FusedFromFYawBzG - Philipp Allgeuer - 20/10/16
% Calculates the fused angles (FGB) with a given fused yaw and global z-axis in body-fixed coordinates (BzG).
%
% function [FGB] = FusedFromFYawBzG(FYaw, BzG)
%
% It is assumed that BzG is a unit vector!

% Main function
function [FGB] = FusedFromFYawBzG(FYaw, BzG)

	% Wrap the fused yaw to the desired range
	FYaw = wrap(FYaw);

	% Calculate the fused pitch
	stheta = max(min(-BzG(1),1.0),-1.0); % Note: If BzG is a unit vector then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the fused roll
	sphi = max(min(BzG(2),1.0),-1.0); % Note: If BzG is a unit vector then this should only trim at most a few eps...
	phi = asin(sphi);

	% See which hemisphere we're in
	if BzG(3) >= 0
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	FGB = [FYaw theta phi h];

end
% EOF