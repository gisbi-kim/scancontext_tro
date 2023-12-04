% RandQuat.m - Philipp Allgeuer - 05/11/14
% Generates random quaternion rotations.
%
% function [Q] = RandQuat(N)
%
% N ==> Number of random rotations to generate (Default: 1)
% Q ==> Nx4 matrix of random quaternion rotations

% Main function
function [Q] = RandQuat(N)

	% Default arguments
	if nargin < 1
		N = 1;
	end
	if ~isscalar(N)
		error('N should be an integer scalar.');
	end
	if N < 0
		N = 0;
	end
	if N ~= floor(N)
		warning('N should be an integer scalar.');
		N = floor(N);
	end

	% Generate the required number of random rotations
	Q = 2*rand(N,4)-1;
	Q = Q./repmat(sqrt(sum(Q.^2,2)),1,4);

end
% EOF