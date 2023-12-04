% QuatInv.m - Philipp Allgeuer - 05/11/14
% Calculates the inverse of a quaternion rotation.
%
% function [Qinv] = QuatInv(Q)
%
% Note that the calculation internally is merely conjugation, so the input
% quaternion must be of unit magnitude for the output to be valid.
%
% Q    ==> Input quaternion rotation (assumed to have unit norm)
% Qinv ==> Inverse quaternion rotation (i.e. the conjugation)

% Main function
function [Qinv] = QuatInv(Q)

	% Calculate the inverse/conjugation of the quaternion
	Qinv = [Q(1) -Q(2:4)]; % Assumes the quaternion is valid

end
% EOF