% TestFromAxis.m - Philipp Allgeuer - 05/11/14
% Tests:   *FromAxis
% Assumes: RandVec, RandAng, *Equal, *FromQuat
%
% function [Pass] = TestFromAxis(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFromAxis(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 600;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFromAxis', N, Tol);

	%
	% Test QuatFromAxis
	%

	% Begin test
	N = BeginTest('QuatFromAxis', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vec = RandVec(1,5.0)';
		Ang = 3*RandAng;
		C = cos(0.5*Ang);
		S = sin(0.5*Ang);
		if C < 0
			C = -C;
			S = -S;
		end
		B = B && all(QuatFromAxis(Vec,0) == [1 0 0 0]);
		B = B && all(QuatFromAxis('x',Ang) - [C S 0 0] <= Tol);
		B = B && all(QuatFromAxis('y',Ang) - [C 0 S 0] <= Tol);
		B = B && all(QuatFromAxis('z',Ang) - [C 0 0 S] <= Tol);
		B = B && all(QuatFromAxis(Vec,Ang) - [C S*Vec/norm(Vec)] <= Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RotmatFromAxis
	%

	% Begin test
	N = BeginTest('RotmatFromAxis', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vec = RandVec(1,5.0)';
		Ang = 3*RandAng;
		B = B && RotmatEqual(RotmatFromAxis(Vec,0), eye(3), 2*eps);
		B = B && RotmatEqual(RotmatFromAxis('x',Ang), RotmatFromQuat(QuatFromAxis('x',Ang)), Tol);
		B = B && RotmatEqual(RotmatFromAxis('y',Ang), RotmatFromQuat(QuatFromAxis('y',Ang)), Tol);
		B = B && RotmatEqual(RotmatFromAxis('z',Ang), RotmatFromQuat(QuatFromAxis('z',Ang)), Tol);
		B = B && RotmatEqual(RotmatFromAxis(Vec,Ang), RotmatFromQuat(QuatFromAxis(Vec,Ang)), Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test EulerFromAxis
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerFromAxis', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vec = RandVec(1,5.0)';
		Ang = 3*RandAng;
		B = B && EulerEqual(EulerFromAxis(Vec,0), [0 0 0], 2*eps);

		RefQuat = QuatFromAxis('x',Ang);
		[Euler, Quat] = EulerFromAxis('x', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = EulerEqual(Euler, EulerFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('y',Ang);
		[Euler, Quat] = EulerFromAxis('y', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = EulerEqual(Euler, EulerFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('z',Ang);
		[Euler, Quat] = EulerFromAxis('z', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = EulerEqual(Euler, EulerFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis(Vec,Ang);
		[Euler, Quat] = EulerFromAxis(Vec, Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = EulerEqual(Euler, EulerFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Euler representation error', ErrA);

	%
	% Test FusedFromAxis
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedFromAxis', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vec = RandVec(1,5.0)';
		Ang = 3*RandAng;
		B = B && FusedEqual(FusedFromAxis(Vec,0), [0 0 0 1], 2*eps);

		RefQuat = QuatFromAxis('x',Ang);
		[Fused, Quat] = FusedFromAxis('x', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = FusedEqual(Fused, FusedFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('y',Ang);
		[Fused, Quat] = FusedFromAxis('y', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = FusedEqual(Fused, FusedFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('z',Ang);
		[Fused, Quat] = FusedFromAxis('z', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = FusedEqual(Fused, FusedFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis(Vec,Ang);
		[Fused, Quat] = FusedFromAxis(Vec, Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = FusedEqual(Fused, FusedFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Fused representation error', ErrA);

	%
	% Test TiltFromAxis
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltFromAxis', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vec = RandVec(1,5.0)';
		Ang = 3*RandAng;
		B = B && TiltEqual(TiltFromAxis(Vec,0), [0 0 0], 2*eps);

		RefQuat = QuatFromAxis('x',Ang);
		[Tilt, Quat] = TiltFromAxis('x', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = TiltEqual(Tilt, TiltFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('y',Ang);
		[Tilt, Quat] = TiltFromAxis('y', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = TiltEqual(Tilt, TiltFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis('z',Ang);
		[Tilt, Quat] = TiltFromAxis('z', Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = TiltEqual(Tilt, TiltFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);

		RefQuat = QuatFromAxis(Vec,Ang);
		[Tilt, Quat] = TiltFromAxis(Vec, Ang);
		B = B && QuatEqual(Quat, RefQuat, Tol);
		[~, Error] = TiltEqual(Tilt, TiltFromQuat(RefQuat), Tol);
		ErrA(k) = max(ErrA(k), Error);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Tilt representation error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFromAxis', P);

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