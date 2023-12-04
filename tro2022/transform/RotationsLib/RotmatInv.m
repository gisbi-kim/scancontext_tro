% RotmatInv.m - Philipp Allgeuer - 05/11/14
% Calculates the inverse of a rotation matrix.
%
% function [Rinv] = RotmatInv(R)
%
% Note that the calculation internally is merely transposition, so the input
% rotation matrix must be valid itself for the output to be valid.
%
% R    ==> Input rotation matrix
% Rinv ==> Inverse rotation matrix (i.e. the transpose)

% Main function
function [Rinv] = RotmatInv(R)

	% Calculate the inverse/transpose of the rotation matrix
	Rinv = R'; % Assumes the rotation matrix is valid

end
% EOF