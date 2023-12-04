% RandFused.m - Philipp Allgeuer - 05/11/14
% Generates random fused angles rotations.
%
% function [F] = RandFused(N)
%
% N ==> Number of random rotations to generate (Default: 1)
% F ==> Nx4 matrix of random fused angles rotations

% Main function
function [F] = RandFused(N)

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
	yaw = pi*(2*rand(N,1)-1);
	lam = 2*rand(N,2)-1;
	F = [yaw (pi/4)*[lam(:,1)+lam(:,2) lam(:,1)-lam(:,2)] 2*(rand(N,1)>0.5)-1];

end
% EOF