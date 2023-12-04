% RandRotmat.m - Philipp Allgeuer - 05/11/14
% Generates random rotation matrices.
%
% function [R] = RandRotmat(N)
%
% N ==> Number of random rotations to generate (Default: 1)
% R ==> 3x3xN matrix of random rotation matrices

% Main function
function [R] = RandRotmat(N)

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
	Q = RandQuat(N);
	R = zeros(3, 3, N);
	for k = 1:N
		R(:,:,k) = RotmatFromQuat(Q(k,:));
	end

end
% EOF