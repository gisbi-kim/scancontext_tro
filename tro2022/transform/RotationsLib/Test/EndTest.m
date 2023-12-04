% EndTest.m - Philipp Allgeuer - 05/11/14
% Function to be called at the end of an individual test.
%
% function [Pass] = EndTest(Tol, varargin)
%
% Individual tests are intended to be combined into test scripts. Each individual
% test should return PASS/true on completion if the test was successful.
%
% Tol      ==> The numerical bound below which errors in this test are acceptable
% varargin ==> Variable number of error arrays (column vectors or matrices) to display and check
%              The order is 'name1', Err1, 'name2', Err2, ...
% Pass     ==> Boolean flag whether this test was passed

% Main function
function [Pass] = EndTest(Tol, varargin)

	% Default tolerance value
	if nargin < 1 || Tol <= 0
		Tol = 128*eps;
	end

	% Print the error statistics and see whether the test was passed
	Pass = true;
	for k = 1:2:(nargin-2)
		Flag = PrintErrStats(varargin{k+1}, varargin{k}, Tol);
		Pass = Pass & Flag;
		if ~Flag
			warning('Error test(s) failed!');
			disp(' ');
		end
	end

	% Stop timing
	toc;

	% Trailing display
	fprintf('\n');

	% Flush the printed output to screen
	if isOctave
		fflush(stdout);
	else
		drawnow('update');
	end

end
% EOF