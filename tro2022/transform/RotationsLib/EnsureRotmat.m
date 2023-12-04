% EnsureRotmat.m - Philipp Allgeuer - 05/11/14
% Checks whether a rotation matrix is valid to within a certain
% tolerance and fixes it if not.
%
% function [Rout, WasBad] = EnsureRotmat(Rin, Tol)
%
% A 3x3 rotation matrix is valid if R'*R = I and det(R) = 1. Rotation matrices
% that are valid are always automatically unique.
%
% Rin    ==> Input rotation matrix
% Tol    ==> Tolerance bound for the L_inf norm of the input/output difference
% Rout   ==> Output rotation matrix (fixed)
% WasBad ==> Boolean flag whether the input and output differ more than Tol

% Main function
function [Rout, WasBad] = EnsureRotmat(Rin, Tol)

	% Default arguments
	if nargin < 2
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end

	% Make a copy of the input
	Rout = Rin;

	% Orthogonalise the rotation matrix
	Rout = Rout / sqrtm(Rout' * Rout); % Calculate the 'closest' valid rotation matrix to the given one
	if ~isreal(Rout)
		Rout = eye(3);
	end

	% Filter out invalid left hand coordinate systems
	if det(Rout) < 0
		Rout = eye(3);
	end

	% Work out whether we changed anything
	WasBad = any(any(abs(Rout - Rin) > Tol));

end
% EOF