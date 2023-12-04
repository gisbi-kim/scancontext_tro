% TestFromFYawGzB.m - Philipp Allgeuer - 27/10/16
% Tests:   *FromFYawGzB
% Assumes: RandUnitVec, FYawOf*, RotmatFrom*
%
% function [Pass] = TestFromFYawGzB(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFromFYawGzB(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFromFYawGzB', N, Tol);

	%
	% Test EulerFromFYawGzB
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerFromFYawGzB', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerFromFYawGzB(0, [0 0 1]) == [0 0 0]);
	B = B && all(EulerFromFYawGzB(2, [0 0 1]) == [2 0 0]);
	B = B && all(EulerFromFYawGzB(0, [0 0 -1]) == [0 0 pi]);
	B = B && all(EulerFromFYawGzB(2, [0 0 -1]) == [2 0 pi]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		GzB = RandUnitVec(1,3);

		EGB = EulerFromFYawGzB(FYaw, GzB);
		RGB = RotmatFromEuler(EGB);

		ErrFYaw = FYawOfEuler(EGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(RGB(:,3) - GzB);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'EGB output correct', ErrA);

	%
	% Test FusedFromFYawGzB
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedFromFYawGzB', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(FusedFromFYawGzB(0, [0 0 1]) == [0 0 0 1]);
	B = B && all(FusedFromFYawGzB(2, [0 0 1]) == [2 0 0 1]);
	B = B && all(FusedFromFYawGzB(0, [0 0 -1]) == [0 0 0 -1]);
	B = B && all(FusedFromFYawGzB(2, [0 0 -1]) == [2 0 0 -1]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		GzB = RandUnitVec(1,3);

		FGB = FusedFromFYawGzB(FYaw, GzB);
		RGB = RotmatFromFused(FGB);

		ErrFYaw = FGB(1) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(RGB(:,3) - GzB);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'FGB output correct', ErrA);

	%
	% Test QuatFromFYawGzB
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('QuatFromFYawGzB', Nnormal, [1 2]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatFromFYawGzB(0, [0 0 1]) == [1 0 0 0]);
	B = B && all(QuatFromFYawGzB(0, [0 0 -1]) == [0 1 0 0]);
	B = B && all(QuatFromFYawGzB(2, [0 0 -1]) == [0 1 0 0]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		GzB = RandUnitVec(1,3);
		if GzB(3) <= -1
			continue;
		end

		qGB = QuatFromFYawGzB(FYaw, GzB);
		RGB = RotmatFromQuat(qGB);

		ErrA(k,1) = abs(norm(qGB) - 1);

		ErrFYaw = FYawOfQuat(qGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrB(k,1) = abs(ErrFYaw);
		ErrB(k,2) = norm(RGB(:,3) - GzB);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'qGB valid', ErrA, 'qGB output correct', ErrB);

	%
	% Test RotmatFromFYawGzB
	%

	% Begin test
	[N, ErrA, ErrB, ErrC, ErrD] = BeginTest('RotmatFromFYawGzB', Nnormal, [2 1 2 2]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(all(RotmatFromFYawGzB(0, [0 0 1]) == eye(3)));
	B = B && all(all(RotmatFromFYawGzB(0, [0 0 -1]) == diag([1 -1 -1])));
	B = B && all(all(RotmatFromFYawGzB(2, [0 0 -1]) == diag([1 -1 -1])));

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		GzB = RandUnitVec(1,3);
		if GzB(3) <= -1
			continue;
		end

		[RGB, qGB] = RotmatFromFYawGzB(FYaw, GzB);
		RGBq = RotmatFromQuat(qGB);

		ErrA(k,1) = norm(RGB'*RGB - eye(3));
		ErrA(k,2) = abs(det(RGB) - 1);

		ErrB(k,1) = abs(norm(qGB) - 1);

		ErrFYaw = FYawOfRotmat(RGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrC(k,1) = abs(ErrFYaw);
		ErrC(k,2) = norm(RGB(:,3) - GzB);

		ErrFYaw = FYawOfQuat(qGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrD(k,1) = abs(ErrFYaw);
		ErrD(k,2) = norm(RGBq(:,3) - GzB);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'RGB valid', ErrA, 'qGB valid', ErrB, 'RGB output correct', ErrC, 'qGB output correct', ErrD);

	%
	% Test TiltFromFYawGzB
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltFromFYawGzB', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(TiltFromFYawGzB(0, [0 0 1]) == [0 0 0]);
	B = B && all(TiltFromFYawGzB(2, [0 0 1]) == [2 0 0]);
	B = B && all(TiltFromFYawGzB(0, [0 0 -1]) == [0 0 pi]);
	B = B && all(TiltFromFYawGzB(2, [0 0 -1]) == [2 0 pi]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		GzB = RandUnitVec(1,3);

		TGB = TiltFromFYawGzB(FYaw, GzB);
		RGB = RotmatFromTilt(TGB);

		ErrFYaw = TGB(1) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(RGB(:,3) - GzB);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'TGB output correct', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFromFYawGzB', P);

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