% BeginTest.m - Philipp Allgeuer - 05/11/14
% Function to be called at the beginning of an individual test.
%
% function [N, varargout] = BeginTest(Title, N, ErrSize)
%
% Individual tests are intended to be combined into test scripts. Each individual
% test should return PASS/true on completion if the test was successful.
%
% Title     ==> The name to use for this test
% N (in)    ==> The number of test cases to use in the test
% ErrSize   ==> A vector of values specifying the required number of columns in each error array
% N (out)   ==> The number of test cases to use in the test (unmodified from the input)
% varargout ==> The zero-initialised error arrays (NxM where the M values come from the ErrSize input).
%               If more outputs are present than numel(ErrSize), the additional arrays default to
%               being of width 1 (column vectors).

% Main function
function [N, varargout] = BeginTest(Title, N, ErrSize)

	% Start timing
	tic;

	% Print a test header
	fprintf('----------------------------------------------------------------------\n');
	fprintf('TEST: %s\n\n', Title);

	% Initialise the required error arrays with zeros
	if nargin >= 2
		N = round(N);
	end
	if nargin < 3
		ErrSize = [];
	end
	for k = 1:(nargout-1)
		if k <= numel(ErrSize)
			varargout{k} = zeros(N,ErrSize(k));
		else
			varargout{k} = zeros(N,1);
		end
	end

	% Flush the printed output to screen
	if isOctave
		fflush(stdout);
	else
		drawnow('update');
	end

end
% EOF