% TiltFromFYawBzG - Philipp Allgeuer - 20/10/16
% Calculates the tilt angles (TGB) with a given fused yaw and global z-axis in body-fixed coordinates (BzG).
%
% function [TGB] = TiltFromFYawBzG(FYaw, BzG)
%
% It is assumed that BzG is a unit vector!

% Main function
function [TGB] = TiltFromFYawBzG(FYaw, BzG)

	% Wrap the fused yaw to the desired range
	FYaw = wrap(FYaw);

	% Calculate the tilt axis angle
	gamma = atan2(-BzG(1), BzG(2));

	% Calculate the tilt angle
	calpha = max(min(BzG(3),1.0),-1.0); % Note: If BzG is a unit vector then this should only trim at most a few eps...
	alpha = acos(calpha);

	% Construct the output tilt angles
	TGB = [FYaw gamma alpha];

end
% EOF