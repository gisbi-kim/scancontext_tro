% TestFromZVec.m - Philipp Allgeuer - 21/10/16
% Tests:   FromZVec*
% Assumes: RandUnitVec, ZVecFrom*, FYawOf*
%
% function [Pass] = TestFromZVec(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFromZVec(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFromZVec', N, Tol);

	%
	% Test EulerFromZVec
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerFromZVec', Nnormal, 1);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(EulerFromZVec([0 0 1]) == [0 0 0]);
	B = B && all(EulerFromZVec([0 0 -1]) == [0 0 pi]);

	% Perform the required testing
	for k = 1:N
		ZVec = RandUnitVec(1,3)';
		Euler = EulerFromZVec(ZVec);

		ErrA(k,1) = norm(ZVecFromEuler(Euler) - ZVec);
		B = B && (Euler(1) == 0);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Output correct', ErrA);

	%
	% Test FusedFromZVec
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedFromZVec', Nnormal, 1);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(FusedFromZVec([0 0 1]) == [0 0 0 1]);
	B = B && all(FusedFromZVec([0 0 -1]) == [0 0 0 -1]);

	% Perform the required testing
	for k = 1:N
		ZVec = RandUnitVec(1,3)';
		Fused = FusedFromZVec(ZVec);

		ErrA(k,1) = norm(ZVecFromFused(Fused) - ZVec);
		B = B && (Fused(1) == 0);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Output correct', ErrA);

	%
	% Test QuatFromZVec
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('QuatFromZVec', Nnormal, [1 1]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatFromZVec([0 0 1]) == [1 0 0 0]);
	B = B && all(QuatFromZVec([0 0 -1]) == [0 1 0 0]);

	% Perform the required testing
	for k = 1:N
		ZVec = RandUnitVec(1,3)';
		Quat = QuatFromZVec(ZVec);

		ErrA(k,1) = norm(ZVecFromQuat(Quat) - ZVec);
		ErrB(k,1) = abs(norm(Quat) - 1);
		B = B && (Quat(4) == 0);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Output correct', ErrA, 'Output valid', ErrB);

	%
	% Test RotmatFromZVec
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('RotmatFromZVec', Nnormal, [3 3]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(all(RotmatFromZVec([0 0 1]) == eye(3)));
	B = B && all(all(RotmatFromZVec([0 0 -1]) == diag([1 -1 -1])));

	% Perform the required testing
	for k = 1:N
		ZVec = RandUnitVec(1,3)';
		[Rotmat, Quat] = RotmatFromZVec(ZVec);

		ErrA(k,1) = abs(FYawOfRotmat(Rotmat));
		ErrA(k,2) = norm(Rotmat(3,:) - ZVec);
		ErrA(k,3) = norm(ZVecFromQuat(Quat) - ZVec);
		ErrB(k,1) = norm(Rotmat'*Rotmat - eye(3));
		ErrB(k,2) = abs(det(Rotmat) - 1);
		ErrB(k,3) = abs(norm(Quat) - 1);
		B = B && (Quat(4) == 0);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Output correct', ErrA, 'Output valid', ErrB);

	%
	% Test TiltFromZVec
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltFromZVec', Nnormal, 1);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(TiltFromZVec([0 0 1]) == [0 0 0]);
	B = B && all(TiltFromZVec([0 0 -1]) == [0 0 pi]);

	% Perform the required testing
	for k = 1:N
		ZVec = RandUnitVec(1,3)';
		Tilt = TiltFromZVec(ZVec);

		ErrA(k,1) = norm(ZVecFromTilt(Tilt) - ZVec);
		B = B && (Tilt(1) == 0);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Output correct', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFromZVec', P);

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