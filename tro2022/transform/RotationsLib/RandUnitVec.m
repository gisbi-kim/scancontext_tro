% RandUnitVec.m - Philipp Allgeuer - 05/11/14
% Generates random M-vectors of unit norm.
%
% function [V] = RandUnitVec(N, M)
%
% N ==> Number of random unit vectors to generate (Default: 1)
% M ==> Required dimension of each of the generated vectors (Default: 3)
% V ==> MxN matrix of M-vectors expressed as column vectors

% Main function
function [V] = RandUnitVec(N, M)

	% Default arguments
	if nargin < 1
		N = 1;
	end
	if nargin < 2
		M = 3;
	end
	if ~isscalar(N) || ~isscalar(M)
		error('N and M should both be integer scalars.');
	end
	if N < 0
		N = 0;
	end
	if N ~= floor(N)
		warning('N should be an integer scalar.');
		N = floor(N);
	end
	if M < 0
		M = 0;
	end
	if M ~= floor(M)
		warning('M should be an integer scalar.');
		M = floor(M);
	end

	% Generate the required number of random unit vectors
	V = 2*rand(M,N) - 1;
	Vnorm = sqrt(sum(V.^2,1));
	Vnorm(Vnorm == 0) = 1;
	V = V./repmat(Vnorm,M,1);

end
% EOF