% TestZVecFrom.m - Philipp Allgeuer - 20/10/16
% Tests:   ZVecFrom*
% Assumes: Rand*, RotmatFrom*
%
% function [Pass] = TestZVecFrom(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestZVecFrom(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestZVecFrom', N, Tol);

	%
	% Test ZVecFromEuler
	%

	% Begin test
	[N, ErrA] = BeginTest('ZVecFromEuler', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(ZVecFromEuler([0 0 0]) == [0 0 1]);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
		Zr = ZVecFromEuler(Er);

		ErrA(k) = abs(norm(Zr) - 1);

		Rr = RotmatFromEuler(Er);
		B = B && all(Zr == Rr(3,:));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Norm error', ErrA);

	%
	% Test ZVecFromFused
	%

	% Begin test
	[N, ErrA] = BeginTest('ZVecFromFused', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(ZVecFromFused([0 0 0 1]) == [0 0 1]);

	% Perform the required testing
	for k = 1:N
		Fr = RandFused;
		Zr = ZVecFromFused(Fr);

		ErrA(k) = abs(norm(Zr) - 1);

		Rr = RotmatFromFused(Fr);
		B = B && all(Zr == Rr(3,:));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Norm error', ErrA);

	%
	% Test ZVecFromQuat
	%

	% Begin test
	[N, ErrA] = BeginTest('ZVecFromQuat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(ZVecFromQuat([1 0 0 0]) == [0 0 1]);

	% Perform the required testing
	for k = 1:N
		Qr = RandQuat;
		Zr = ZVecFromQuat(Qr);

		ErrA(k) = abs(norm(Zr) - 1);

		Rr = RotmatFromQuat(Qr);
		B = B && all(Zr == Rr(3,:));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Norm error', ErrA);

	%
	% Test ZVecFromRotmat
	%

	% Begin test
	[N, ErrA] = BeginTest('ZVecFromRotmat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(ZVecFromRotmat(eye(3)) == [0 0 1]);

	% Perform the required testing
	for k = 1:N
		Rr = RandRotmat;
		Zr = ZVecFromRotmat(Rr);

		ErrA(k) = abs(norm(Zr) - 1);

		B = B && all(Zr == Rr(3,:));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Norm error', ErrA);

	%
	% Test ZVecFromTilt
	%

	% Begin test
	[N, ErrA] = BeginTest('ZVecFromTilt', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(ZVecFromTilt([0 0 0]) == [0 0 1]);

	% Perform the required testing
	for k = 1:N
		Tr = RandTilt;
		Zr = ZVecFromTilt(Tr);

		ErrA(k) = abs(norm(Zr) - 1);

		Rr = RotmatFromTilt(Tr);
		B = B && all(Zr == Rr(3,:));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Norm error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestZVecFrom', P);

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