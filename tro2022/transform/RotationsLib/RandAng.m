% RandAng.m - Philipp Allgeuer - 05/11/14
% Generates a random angle.
%
% function [Ang] = RandAng(N, Range)
%
% If Range is omitted then random angles in [-pi,pi] are generated. If Range is
% scalar then random angles in [0,Range] are generated. If Range is a vector of
% length 2 then random angles in [Range(1),Range(2)] are generated. If Range(2)
% is less than Range(1) then the two values are swapped.
%
% N     ==> Number of random angles to generate (Default: 1)
% Range ==> Allowed range of the generated angles (Default: [-pi,pi])
% Ang   ==> Nx1 column vector of random angle(s)

% Main function
function [Ang] = RandAng(N, Range)

	% Default arguments
	if nargin < 1
		N = 1;
	end
	if nargin < 2
		Range = [-pi,pi];
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
	if isscalar(Range)
		Range = [0,Range];
	end
	if Range(2) < Range(1)
		Range = [Range(2) Range(1)];
	end

	% Generate the required number of random angles
	Diff = Range(2) - Range(1);
	Ang = Range(1) + Diff*rand(N,1);

end
% EOF