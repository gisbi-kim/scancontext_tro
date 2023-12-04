% FusedEqual.m - Philipp Allgeuer - 05/11/14
% Returns whether two fused angles rotations represent the same rotation.
%
% function [Equal, Err] = FusedEqual(F, G, Tol)
%
% Refer to EnsureFused for more information on the unique form of a fused
% angles rotation.
%
% F     ==> First fused angles rotation to compare
% G     ==> Second fused angles rotation to compare
% Tol   ==> Allowed tolerance between F and G for which equality is still asserted
% Equal ==> Boolean flag whether F equals G to the given L_inf norm tolerance
% Err   ==> The quantified error between F and G (0 if exactly equal)

% Main function
function [Equal, Err] = FusedEqual(F, G, Tol)

	% Default tolerance
	if nargin < 3
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end
	
	% Get the required value of pi
	PI = GetPI(F);

	% Convert both fused angles into their unique representations
	F = EnsureFused(F, Tol, true);
	G = EnsureFused(G, Tol, true);

	% Handle angle wrapping issues
	if abs(F(1)-G(1)) > PI
		if F(1) > G(1)
			G(1) = G(1) + 2*PI;
		else
			F(1) = F(1) + 2*PI;
		end
	end

	% Construct the vectors to compare
	% The fused pitch and roll suffer from the numerical insensitivity of asin, so the sin thereof is checked
	FComp = [F(1) sin(F(2)) sin(F(3)) F(4)];
	GComp = [G(1) sin(G(2)) sin(G(3)) G(4)];

	% Calculate the deviation between the two rotations
	Err = max(abs(FComp-GComp));

	% Check whether the two rotations are within tolerance
	Equal = (Err <= Tol);

end
% EOF