% TestIdentity.m - Philipp Allgeuer - 05/11/14
% Tests:   *Identity
% Assumes: None
%
% function [Pass] = TestIdentity(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestIdentity(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 1;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	P = BeginTestScript('TestIdentity', N, Tol);

	%
	% Test *Identity
	%

	% Begin test
	BeginTest('*Identity');
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerIdentity == [0 0 0]);
	B = B && all(FusedIdentity == [0 0 0 1]);
	B = B && all(QuatIdentity == [1 0 0 0]);
	B = B && all(all(RotmatIdentity == eye(3)));
	B = B && all(TiltIdentity == [0 0 0]);

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestIdentity', P);

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