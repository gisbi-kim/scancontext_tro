% TiltFromFYawGzB - Philipp Allgeuer - 26/10/16
% Calculates the tilt angles (TGB) with a given fused yaw and body-fixed z-axis in global coordinates (GzB).
%
% function [TGB] = TiltFromFYawGzB(FYaw, GzB)
%
% It is assumed that GzB is a unit vector!

% Main function
function [TGB] = TiltFromFYawGzB(FYaw, GzB)

	% Wrap the fused yaw to the desired range
	FYaw = wrap(FYaw);

	% Calculate the tilt axis angle
	if GzB(1) == 0 && GzB(2) == 0
		gamma = 0;
	else
		gamma = atan2(GzB(1), -GzB(2)) - FYaw;
		gamma = wrap(gamma);
	end

	% Calculate the tilt angle
	calpha = max(min(GzB(3),1.0),-1.0); % Note: If GzB is a unit vector then this should only trim at most a few eps...
	alpha = acos(calpha);

	% Construct the tilt angles representation
	TGB = [FYaw gamma alpha];

end
% EOF