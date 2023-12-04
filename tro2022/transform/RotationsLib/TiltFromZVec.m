% TiltFromZVec.m - Philipp Allgeuer - 21/10/16
% Converts a z-vector to the corresponding zero fused yaw tilt angles representation.
%
% function [Tilt] = TiltFromZVec(ZVec)
%
% It is assumed that ZVec is a unit vector!
%
% ZVec ==> Input z-vector
% Tilt ==> Corresponding zero fused yaw tilt angles rotation

% Main function
function [Tilt] = TiltFromZVec(ZVec)

	% Calculate the tilt axis angle
	gamma = atan2(-ZVec(1),ZVec(2));

	% Calculate the tilt angle alpha
	calpha = max(min(ZVec(3),1.0),-1.0); % Note: If ZVec is a unit vector then this should only trim at most a few eps...
	alpha = acos(calpha);

	% Return the tilt angles representation
	Tilt = [0 gamma alpha];

end
% EOF