% TiltEqual.m - Philipp Allgeuer - 05/11/14
% Returns whether two tilt angles rotations represent the same rotation.
%
% function [Equal, Err] = TiltEqual(T, U, Tol)
%
% Refer to EnsureTilt for more information on the unique form of a tilt
% angles rotation.
%
% T     ==> First tilt angles rotation to compare
% U     ==> Second tilt angles rotation to compare
% Tol   ==> Allowed tolerance between T and U for which equality is still asserted
% Equal ==> Boolean flag whether T equals U to the given L_inf norm tolerance
% Err   ==> The quantified error between T and U (0 if exactly equal)

% Main function
function [Equal, Err] = TiltEqual(T, U, Tol)

	% Default tolerance
	if nargin < 3
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end
	
	% Get the required value of pi
	PI = GetPI(T);

	% Convert both tilt angles into their unique representations
	T = EnsureTilt(T, Tol, true);
	U = EnsureTilt(U, Tol, true);

	% Handle angle wrapping issues
	if abs(T(1)-U(1)) > PI
		if T(1) > U(1)
			U(1) = U(1) + 2*PI;
		else
			T(1) = T(1) + 2*PI;
		end
	end

	% Construct the vectors to compare
	% The tilt axis angle has a singularity when the tilt angle is zero, so a geometrically relevant term is checked instead of the tilt axis angle directly
	% The tilt angle suffers from the numerical sensitivity of acos, so the cos thereof is checked
	TComp = [T(1) (sin(T(3))^2)*[cos(T(2)) sin(T(2))] cos(T(3))];
	UComp = [U(1) (sin(U(3))^2)*[cos(U(2)) sin(U(2))] cos(U(3))];

	% Calculate the deviation between the two rotations
	Err = max(abs(TComp-UComp));

	% Check whether the two rotations are within tolerance
	Equal = (Err <= Tol);

end
% EOF