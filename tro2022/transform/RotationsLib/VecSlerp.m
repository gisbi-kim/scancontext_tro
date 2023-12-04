% VecSlerp.m - Philipp Allgeuer - 17/02/17
% Calculates spherical linear interpolation (slerp) for arbitrary vectors.
%
% function [Vu] = VecSlerp(V1, V2, u)
%
% V1 ==> Vector to interpolate from (u = 0)
% V2 ==> Vector to interpolate to (u = 1)
% u  ==> Dimensionless parameter at which to evaluate the interpolation
% Vu ==> Interpolated output vector
%
% The input vectors do not have to be unit vectors, as long as they are not zero, but the
% output vector is a unit vector.

% Main function
function [Vu] = VecSlerp(V1, V2, u)

	% See whether the output will have to be flipped at the end
	flip = (size(V1,1) > size(V1,2));

	% Normalise the input vectors
	normV1 = norm(V1);
	normV2 = norm(V2);
	if normV1 <= 0 || normV2 <= 0
		warning('The vectors to interpolate should not be zero!');
		Vu = zeros(size(V1));
		return
	end
	V1 = V1(:)' / normV1;
	V2 = V2(:)' / normV2;

	% Ensure u is the right shape for vectorisation
	u = u(:);

	% Calculate the dot product of the two vectors
	dprod = dot(V1, V2);

	% If V1 and V2 are close enough together then just use linear interpolation, otherwise perform spherical linear interpolation
	if dprod >= 1 - 5e-9 % A dot product within this tolerance of unity produces a negligible amount of error if using linear interpolation instead
		Vu = (1-u)*V1 + u*V2;
	else
		htheta = acos(dprod);
		Vu = sin((1-u)*htheta)*V1 + sin(u*htheta)*V2;
	end

	% Normalise the output vectors
	Vu = Vu./sqrt(sum(Vu.^2,2));

	% Flip the output if appropriate
	if flip
		Vu = Vu';
	end

end
% EOF