% QuatEqual.m - Philipp Allgeuer - 05/11/14
% Returns whether two quaternion rotations represent the same rotation.
%
% function [Equal, Err] = QuatEqual(P, Q, Tol)
%
% Two quaternions P and Q are equivalent iff P == Q or P == -Q.
% Refer to EnsureQuat for more information on the unique form of a
% quaternion rotation.
%
% P     ==> First quaternion rotation to compare
% Q     ==> Second quaternion rotation to compare
% Tol   ==> Allowed tolerance between P and Q for which equality is still asserted
% Equal ==> Boolean flag whether P equals Q to the given L_inf norm tolerance
% Err   ==> The quantified error between P and Q (0 if exactly equal)

% Main function
function [Equal, Err] = QuatEqual(P, Q, Tol)

	% Default tolerance
	if nargin < 3
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end

	% Calculate the deviation between the two rotations
	ErrPos = max(abs(P-Q));
	ErrNeg = max(abs(P+Q));
	Err = min(ErrPos,ErrNeg);

	% Check whether the two rotations are within tolerance
	Equal = (Err <= Tol);

end
% EOF