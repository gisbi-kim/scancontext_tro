% RotmatEqual.m - Philipp Allgeuer - 05/11/14
% Returns whether two rotation matrices represent the same rotation.
%
% function [Equal, Err] = RotmatEqual(Ra, Rb, Tol)
%
% Two rotation matrices are equivalent iff they are equal as matrices.
% Refer to EnsureRotmat for more information on rotation matrices.
%
% Ra    ==> First rotation matrix to compare
% Rb    ==> Second rotation matrix to compare
% Tol   ==> Allowed tolerance between Ra and Rb for which equality is still asserted
% Equal ==> Boolean flag whether Ra equals Rb to the given L_inf norm tolerance
% Err   ==> The quantified error between Ra and Rb (0 if exactly equal)

% Main function
function [Equal, Err] = RotmatEqual(Ra, Rb, Tol)

	% Default tolerance
	if nargin < 3
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end

	% Calculate the deviation between the two rotations
	Err = max(abs(Ra(:)-Rb(:)));

	% Check whether the two rotations are within tolerance
	Equal = (Err <= Tol);

end
% EOF