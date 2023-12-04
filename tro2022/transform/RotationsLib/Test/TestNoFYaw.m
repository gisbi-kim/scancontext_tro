% TestNoFYaw.m - Philipp Allgeuer - 05/11/14
% Tests:   *NoFYaw
% Assumes: Rand*, FusedEqual, FusedFrom*
%
% function [Pass] = TestNoFYaw(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestNoFYaw(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 1500;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestNoFYaw', N, Tol);

	%
	% Test EulerNoFYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerNoFYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerNoFYaw([0 0 0]) == [0 0 0]);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
		Fr = FusedFromEuler(Er);
		Fnoyaw = FusedFromEuler(EulerNoFYaw(Er));
		[~, ErrA(k)] = FusedEqual([0 Fr(2:4)], Fnoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Fused representation error', ErrA);

	%
	% Test FusedNoFYaw
	%

	% Begin test
	N = BeginTest('FusedNoFYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(FusedNoFYaw([0 0 0 1]) == [0 0 0 1]);
	for k = 1:N
		Fr = RandFused;
		B = B && all(FusedNoFYaw(Fr) == [0 Fr(2:4)]);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test QuatNoFYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('QuatNoFYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatNoFYaw([1 0 0 0]) == [1 0 0 0]);

	% Perform the required testing
	for k = 1:N
		Qr = RandQuat;
		Fr = FusedFromQuat(Qr);
		Fnoyaw = FusedFromQuat(QuatNoFYaw(Qr));
		[~, ErrA(k)] = FusedEqual([0 Fr(2:4)], Fnoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Fused representation error', ErrA);

	%
	% Test RotmatNoFYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('RotmatNoFYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(all(RotmatNoFYaw(eye(3)) == eye(3)));

	% Perform the required testing
	for k = 1:N
		Rr = RandRotmat;
		Fr = FusedFromRotmat(Rr);
		Fnoyaw = FusedFromRotmat(RotmatNoFYaw(Rr));
		[~, ErrA(k)] = FusedEqual([0 Fr(2:4)], Fnoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Fused representation error', ErrA);

	%
	% Test TiltNoFYaw
	%

	% Begin test
	N = BeginTest('TiltNoFYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(TiltNoFYaw([0 0 0]) == [0 0 0]);
	for k = 1:N
		Tr = RandTilt;
		B = B && all(TiltNoFYaw(Tr) == [0 Tr(2:3)]);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestNoFYaw', P);

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