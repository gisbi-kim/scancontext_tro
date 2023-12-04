% QuatSlerp.m - Philipp Allgeuer - 03/12/14
% Calculates spherical linear interpolation (slerp) for quaternions.
%
% function [Qu] = QuatSlerp(Q1, Q2, u)
%
% The output quaternion Qu is either on an interpolated path from Q1 to Q2,
% or Q1 to -Q2, depending on the sign of the dot product of the two quaternions.
%
% Q1 ==> Quaternion to interpolate from (u = 0)
% Q2 ==> Quaternion to interpolate to (u = 1)
% u  ==> Dimensionless parameter at which to evaluate the interpolation
% Qu ==> Interpolated output quaternion

% Main function
function [Qu] = QuatSlerp(Q1, Q2, u)

	% Ensure u is of the right shape for vectorisation
	u = u(:);

	% Calculate the dot product of the two quaternions
	dprod = Q1(1)*Q2(1) + Q1(2)*Q2(2) + Q1(3)*Q2(3) + Q1(4)*Q2(4);
	if dprod < 0
		Q2 = -Q2;
		dprod = -dprod;
	end

	% If Q1 and Q2 are close enough together then just use linear interpolation with normalisation
	if dprod >= 1 - 5e-9 % A dot product within this tolerance of unity produces a negligible amount of error if using linear interpolation instead

		% Perform the required interpolation
		Qu = (1-u)*Q1 + u*Q2;

	else

		% Calculate half the angle between the two quaternions
		htheta = acos(dprod);

		% Calculate the required interpolation
		Qu = sin((1-u)*htheta)*Q1 + sin(u*htheta)*Q2;

	end

	% Normalise the output quaternion
	Qu = Qu./repmat(sqrt(sum(Qu.^2,2)),1,4);

end
% EOF