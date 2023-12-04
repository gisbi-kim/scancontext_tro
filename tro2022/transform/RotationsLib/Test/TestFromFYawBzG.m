% TestFromFYawBzG.m - Philipp Allgeuer - 14/10/16
% Tests:   *FromFYawBzG
% Assumes: RandUnitVec, FYawOf*, ZVecFrom*
%
% function [Pass] = TestFromFYawBzG(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFromFYawBzG(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFromFYawBzG', N, Tol);

	%
	% Test EulerFromFYawBzG
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerFromFYawBzG', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerFromFYawBzG(0, [0 0 1]) == [0 0 0]);
	B = B && all(EulerFromFYawBzG(2, [0 0 1]) == [2 0 0]);
	B = B && all(EulerFromFYawBzG(0, [0 0 -1]) == [0 0 pi]);
	B = B && all(EulerFromFYawBzG(2, [0 0 -1]) == [2 0 pi]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		BzG = RandUnitVec(1,3)';

		EGB = EulerFromFYawBzG(FYaw, BzG);

		ErrFYaw = FYawOfEuler(EGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(ZVecFromEuler(EGB) - BzG);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'EGB output correct', ErrA);

	%
	% Test FusedFromFYawBzG
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedFromFYawBzG', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(FusedFromFYawBzG(0, [0 0 1]) == [0 0 0 1]);
	B = B && all(FusedFromFYawBzG(2, [0 0 1]) == [2 0 0 1]);
	B = B && all(FusedFromFYawBzG(0, [0 0 -1]) == [0 0 0 -1]);
	B = B && all(FusedFromFYawBzG(2, [0 0 -1]) == [2 0 0 -1]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		BzG = RandUnitVec(1,3)';

		FGB = FusedFromFYawBzG(FYaw, BzG);

		ErrFYaw = FGB(1) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(ZVecFromFused(FGB) - BzG);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'FGB output correct', ErrA);

	%
	% Test QuatFromFYawBzG
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('QuatFromFYawBzG', Nnormal, [1 2]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatFromFYawBzG(0, [0 0 1]) == [1 0 0 0]);
	B = B && all(QuatFromFYawBzG(0, [0 0 -1]) == [0 1 0 0]);
	B = B && all(QuatFromFYawBzG(2, [0 0 -1]) == [0 1 0 0]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		BzG = RandUnitVec(1,3)';
		if BzG(3) <= -1
			continue;
		end

		qGB = QuatFromFYawBzG(FYaw, BzG);

		ErrA(k,1) = abs(norm(qGB) - 1);

		ErrFYaw = FYawOfQuat(qGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrB(k,1) = abs(ErrFYaw);
		ErrB(k,2) = norm(ZVecFromQuat(qGB) - BzG);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'qGB valid', ErrA, 'qGB output correct', ErrB);

	%
	% Test RotmatFromFYawBzG
	%

	% Begin test
	[N, ErrA, ErrB, ErrC, ErrD] = BeginTest('RotmatFromFYawBzG', Nnormal, [2 1 2 2]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(all(RotmatFromFYawBzG(0, [0 0 1]) == eye(3)));
	B = B && all(all(RotmatFromFYawBzG(0, [0 0 -1]) == diag([1 -1 -1])));
	B = B && all(all(RotmatFromFYawBzG(2, [0 0 -1]) == diag([1 -1 -1])));

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		BzG = RandUnitVec(1,3)';
		if BzG(3) <= -1
			continue;
		end

		[RGB, qGB] = RotmatFromFYawBzG(FYaw, BzG);

		ErrA(k,1) = norm(RGB'*RGB - eye(3));
		ErrA(k,2) = abs(det(RGB) - 1);

		ErrB(k,1) = abs(norm(qGB) - 1);

		ErrFYaw = FYawOfRotmat(RGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrC(k,1) = abs(ErrFYaw);
		ErrC(k,2) = norm(RGB(3,:) - BzG);

		ErrFYaw = FYawOfQuat(qGB) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrD(k,1) = abs(ErrFYaw);
		ErrD(k,2) = norm(ZVecFromQuat(qGB) - BzG);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'RGB valid', ErrA, 'qGB valid', ErrB, 'RGB output correct', ErrC, 'qGB output correct', ErrD);

	%
	% Test TiltFromFYawBzG
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltFromFYawBzG', Nnormal, 2);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(TiltFromFYawBzG(0, [0 0 1]) == [0 0 0]);
	B = B && all(TiltFromFYawBzG(2, [0 0 1]) == [2 0 0]);
	B = B && all(TiltFromFYawBzG(0, [0 0 -1]) == [0 0 pi]);
	B = B && all(TiltFromFYawBzG(2, [0 0 -1]) == [2 0 pi]);

	% Perform the required testing
	for k = 1:N
		FYaw = 4*pi*(2*rand - 1);
		BzG = RandUnitVec(1,3)';

		TGB = TiltFromFYawBzG(FYaw, BzG);

		ErrFYaw = TGB(1) - FYaw;
		ErrFYaw = pi - mod(pi - ErrFYaw, 2*pi);
		ErrA(k,1) = abs(ErrFYaw);
		ErrA(k,2) = norm(ZVecFromTilt(TGB) - BzG);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'TGB output correct', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFromFYawBzG', P);

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