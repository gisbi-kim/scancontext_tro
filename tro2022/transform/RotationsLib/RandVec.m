% RandVec.m - Philipp Allgeuer - 05/11/14
% Generates random 3-vectors of up to a given norm.
%
% function [V] = RandVec(N, MaxNorm)
%
% N       ==> Number of random vectors to generate (Default: 1)
% MaxNorm ==> Maximum norm of the generated vectors (i.e. norm range is [0,MaxNorm])
% V       ==> 3xN matrix of 3-vectors expressed as column vectors

% Main function
function [V] = RandVec(N, MaxNorm)

	% Default arguments
	if nargin < 1
		N = 1;
	end
	if nargin < 2
		MaxNorm = 1;
	end
	if ~isscalar(N) || ~isscalar(MaxNorm)
		error('N and MaxNorm should each be scalar values.');
	end
	if N < 0
		N = 0;
	end
	if N ~= floor(N)
		warning('N should be an integer scalar.');
		N = floor(N);
	end
	if MaxNorm < 0
		MaxNorm = 0;
	end

	% Generate the required number of random vectors
	RealNorm = MaxNorm * rand(1,N);
	V = 2*rand(3,N) - 1;
	Vnorm = sqrt(V(1,:).^2 + V(2,:).^2 + V(3,:).^2);
	Vnorm(Vnorm == 0) = 1;
	V = V.*repmat(RealNorm./Vnorm,3,1);

end
% EOF