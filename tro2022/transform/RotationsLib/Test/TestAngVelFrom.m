% TestAngVelFrom.m - Philipp Allgeuer - 05/11/14
% Tests:   AngVelFrom*
% Assumes: Rand*, RandUnitVec, QuatFrom*, QuatInv, ComposeQuat
%
% function [Pass] = TestAngVelFrom(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestAngVelFrom(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 650;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestAngVelFrom', N, Tol);

	%
	% Test AngVelFromEulerVel
	%

	% Begin test
	[N, ErrA] = BeginTest('AngVelFromEulerVel', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		dt = 1e-6;
		Er = RandEuler;
		B = B && all(AngVelFromEulerVel(Er,[0 0 0]) == [0;0;0]);
		dE = 3*(2*rand-1)*RandUnitVec(1,3)';
		AngVel = AngVelFromEulerVel(Er,dE);
		dQ = ComposeQuat(QuatFromEuler(Er+dE*dt), QuatInv(QuatFromEuler(Er-dE*dt)));
		ErrA(k) = norm(AngVel - (dQ(2:4)'/dt));
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'AngVel error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestAngVelFrom', P);

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