% TESTTEMPLATE.m - Philipp Allgeuer - DATE
% Tests:   FUNCTION_LIST1
% Assumes: FUNCTION_LIST2
%
% function [Pass] = TESTTEMPLATE(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TESTTEMPLATE(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 100; % TODO: Set a meaningful default N
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TESTTEMPLATE', N, Tol);

	%
	% Test FUNCTION
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('FUNCTION', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && BOOLEAN_TESTS;

	% Perform the required testing
	TESTS_THAT_CALCULATE_ERRORS_ERRA_AND_ERRB;

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'TESTITEMNAME1', ErrA, 'TESTITEMNAME2', ErrB);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TESTTEMPLATE', P);

	% Set the output pass flag
	if nargout >= 1
		Pass = P;
	end

	% Clear the function variable workspace
	if isOctave
		clear -x Pass
	else
		clearvars -except Pass
	end

end
% EOF