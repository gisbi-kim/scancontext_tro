% QuatFromFYawBzG - Philipp Allgeuer - 19/10/16
% Calculates the quaternion (qGB) with a given fused yaw and global z-axis in body-fixed coordinates (BzG).
%
% function [qGB] = QuatFromFYawBzG(FYaw, BzG)
%
% It is assumed that BzG is a unit vector!

% Main function
function [qGB] = QuatFromFYawBzG(FYaw, BzG)

	% Precalculate trigonometric terms
	chpsi = cos(FYaw/2);
	shpsi = sin(FYaw/2);

	% Calculate the w and z components
	wsqpluszsq = min(max((1 + BzG(3))/2, 0), 1); % Note: If BzG is a unit vector then this should only trim at most a few eps...
	wznorm = sqrt(wsqpluszsq);
	w = wznorm * chpsi;
	z = wznorm * shpsi;

	% Calculate the x and y components
	xsqplusysq = 1 - wsqpluszsq;
	xtilde = BzG(1)*z + BzG(2)*w;
	ytilde = BzG(2)*z - BzG(1)*w;
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
	qGB = [w x y z];

end
% EOF