% TestNoEYaw.m - Philipp Allgeuer - 05/11/14
% Tests:   *NoEYaw
% Assumes: Rand*, *Equal, EulerFrom*, RotmatFromQuat
%
% function [Pass] = TestNoEYaw(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestNoEYaw(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 1600;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestNoEYaw', N, Tol);

	%
	% Test EulerNoEYaw
	%

	% Begin test
	N = BeginTest('EulerNoEYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerNoEYaw([0 0 0]) == [0 0 0]);
	for k = 1:N
		Er = RandEuler;
		B = B && all(EulerNoEYaw(Er) == [0 Er(2:3)]);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test FusedNoEYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedNoEYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(FusedNoEYaw([0 0 0 1]) == [0 0 0 1]);

	% Perform the required testing
	for k = 1:N
		Fr = RandFused;
		Er = EulerFromFused(Fr);
		Enoyaw = EulerFromFused(FusedNoEYaw(Fr));
		[~, ErrA(k)] = EulerEqual([0 Er(2:3)], Enoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Euler representation error', ErrA);

	%
	% Test QuatNoEYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('QuatNoEYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatNoEYaw([1 0 0 0]) == [1 0 0 0]);

	% Perform the required testing
	for k = 1:N
		Qr = RandQuat;
		Rr = RotmatFromQuat(Qr);
		Rnoyaw = RotmatFromQuat(QuatNoEYaw(Qr));
		[~, ErrA(k)] = RotmatEqual(RotmatNoEYaw(Rr), Rnoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotmat representation error', ErrA);

	%
	% Test RotmatNoEYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('RotmatNoEYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(all(RotmatNoEYaw(eye(3)) == eye(3)));

	% Perform the required testing
	for k = 1:N
		Rr = RandRotmat;
		Er = EulerFromRotmat(Rr);
		Enoyaw = EulerFromRotmat(RotmatNoEYaw(Rr));
		[~, ErrA(k)] = EulerEqual([0 Er(2:3)], Enoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Euler representation error', ErrA);

	%
	% Test TiltNoEYaw
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltNoEYaw', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(TiltNoEYaw([0 0 0]) == [0 0 0]);

	% Perform the required testing
	for k = 1:N
		Tr = RandTilt;
		Er = EulerFromTilt(Tr);
		Enoyaw = EulerFromTilt(TiltNoEYaw(Tr));
		[~, ErrA(k)] = EulerEqual([0 Er(2:3)], Enoyaw, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Euler representation error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestNoEYaw', P);

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