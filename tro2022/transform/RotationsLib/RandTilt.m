% RandTilt.m - Philipp Allgeuer - 05/11/14
% Generates random tilt angles rotations.
%
% function [T] = RandTilt(N)
%
% N ==> Number of random rotations to generate (Default: 1)
% T ==> Nx3 matrix of random tilt angles rotations

% Main function
function [T] = RandTilt(N)

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
	T = (2*rand(N,3)-1)*(pi*diag([1 1 0.5])) + repmat([0 0 0.5*pi],N,1);

end
% EOF