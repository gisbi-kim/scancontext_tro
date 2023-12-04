% RandEuler.m - Philipp Allgeuer - 05/11/14
% Generates random ZYX Euler angles rotations.
%
% function [E] = RandEuler(N)
%
% N ==> Number of random rotations to generate (Default: 1)
% E ==> Nx3 matrix of random ZYX Euler angles rotations

% Main function
function [E] = RandEuler(N)

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
	E = (2*rand(N,3)-1)*(pi*diag([1 0.5 1]));

end
% EOF