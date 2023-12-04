% TestEYawOf.m - Philipp Allgeuer - 05/11/14
% Tests:   EYawOf*
% Assumes: Rand*, EulerFrom*
%
% function [Pass] = TestEYawOf(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestEYawOf(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestEYawOf', N, Tol);

	%
	% Test EYawOfEuler
	%

	% Begin test
	N = BeginTest('EYawOfEuler', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (EYawOfEuler([0 0 0]) == 0);
	for k = 1:N
		Er = RandEuler;
		B = B && (EYawOfEuler(Er) == Er(1));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test EYawOfFused
	%

	% Begin test
	[N, ErrA] = BeginTest('EYawOfFused', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (EYawOfFused([0 0 0 1]) == 0);

	% Perform the required testing
	for k = 1:N
		Fr = RandFused;
		Er = EulerFromFused(Fr);
		FEYaw = EYawOfFused(Fr);
		EEYaw = Er(1);
		if abs(FEYaw-EEYaw) > pi
			if FEYaw > EEYaw
				EEYaw = EEYaw + 2*pi;
			else
				FEYaw = FEYaw + 2*pi;
			end
		end
		ErrA(k) = abs(FEYaw - EEYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'EYaw error', ErrA);

	%
	% Test EYawOfQuat
	%

	% Begin test
	[N, ErrA] = BeginTest('EYawOfQuat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (EYawOfQuat([1 0 0 0]) == 0);

	% Perform the required testing
	for k = 1:N
		Qr = RandQuat;
		Er = EulerFromQuat(Qr);
		QEYaw = EYawOfQuat(Qr);
		EEYaw = Er(1);
		if abs(QEYaw-EEYaw) > pi
			if QEYaw > EEYaw
				EEYaw = EEYaw + 2*pi;
			else
				QEYaw = QEYaw + 2*pi;
			end
		end
		ErrA(k) = abs(QEYaw - EEYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'EYaw error', ErrA);

	%
	% Test EYawOfRotmat
	%

	% Begin test
	[N, ErrA] = BeginTest('EYawOfRotmat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (EYawOfRotmat(eye(3)) == 0);

	% Perform the required testing
	for k = 1:N
		Rr = RandRotmat;
		Er = EulerFromRotmat(Rr);
		REYaw = EYawOfRotmat(Rr);
		EEYaw = Er(1);
		if abs(REYaw-EEYaw) > pi
			if REYaw > EEYaw
				EEYaw = EEYaw + 2*pi;
			else
				REYaw = REYaw + 2*pi;
			end
		end
		ErrA(k) = abs(REYaw - EEYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'EYaw error', ErrA);

	%
	% Test EYawOfTilt
	%

	% Begin test
	[N, ErrA] = BeginTest('EYawOfTilt', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (EYawOfTilt([0 0 0]) == 0);

	% Perform the required testing
	for k = 1:N
		Tr = RandTilt;
		Er = EulerFromTilt(Tr);
		TEYaw = EYawOfTilt(Tr);
		EEYaw = Er(1);
		if abs(TEYaw-EEYaw) > pi
			if TEYaw > EEYaw
				EEYaw = EEYaw + 2*pi;
			else
				TEYaw = TEYaw + 2*pi;
			end
		end
		ErrA(k) = abs(TEYaw - EEYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'EYaw error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestEYawOf', P);

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