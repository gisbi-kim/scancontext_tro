% FusedFromZVec.m - Philipp Allgeuer - 21/10/16
% Converts a z-vector to the corresponding zero fused yaw fused angles representation.
%
% function [Fused] = FusedFromZVec(ZVec)
%
% It is assumed that ZVec is a unit vector!
%
% ZVec  ==> Input z-vector
% Fused ==> Corresponding zero fused yaw fused angles rotation

% Main function
function [Fused] = FusedFromZVec(ZVec)

	% Calculate the fused pitch
	stheta = max(min(-ZVec(1),1.0),-1.0); % Note: If ZVec is a unit vector then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the fused roll
	sphi = max(min(ZVec(2),1.0),-1.0); % Note: If ZVec is a unit vector then this should only trim at most a few eps...
	phi = asin(sphi);

	% See which hemisphere we're in
	if ZVec(3) >= 0
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	Fused = [0 theta phi h];

end
% EOF