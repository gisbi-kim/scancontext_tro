% QuatFromZVec.m - Philipp Allgeuer - 21/10/16
% Converts a z-vector to the corresponding zero fused yaw quaternion representation.
%
% function [Quat] = QuatFromZVec(ZVec)
%
% It is assumed that ZVec is a unit vector!
%
% ZVec ==> Input z-vector
% Quat ==> Corresponding zero fused yaw quaternion rotation

% Main function
function [Quat] = QuatFromZVec(ZVec)

	% Calculate the w component
	wsq = min(max((1 + ZVec(3))/2, 0), 1); % Note: If ZVec is a unit vector then this should only trim at most a few eps...
	w = sqrt(wsq);

	% Calculate the x and y components
	xsqplusysq = 1 - wsq;
	xtilde = ZVec(2);
	ytilde = -ZVec(1);
	xytildenormsq = xtilde*xtilde + ytilde*ytilde;
	if xytildenormsq <= 0
		x = sqrt(xsqplusysq);
		y = 0;
	else
		factor = sqrt(xsqplusysq / xytildenormsq);
		x = factor * xtilde;
		y = factor * ytilde;
	end

	% Construct the output quaternion
	Quat = [w x y 0];

end
% EOF