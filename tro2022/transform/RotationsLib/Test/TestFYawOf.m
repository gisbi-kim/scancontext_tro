% TestFYawOf.m - Philipp Allgeuer - 05/11/14
% Tests:   FYawOf*
% Assumes: Rand*, FusedFrom*
%
% function [Pass] = TestFYawOf(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFYawOf(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFYawOf', N, Tol);

	%
	% Test FYawOfEuler
	%

	% Begin test
	[N, ErrA] = BeginTest('FYawOfEuler', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (FYawOfEuler([0 0 0]) == 0);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
		Fr = FusedFromEuler(Er);
		EFYaw = FYawOfEuler(Er);
		FFYaw = Fr(1);
		if abs(EFYaw-FFYaw) > pi
			if EFYaw > FFYaw
				FFYaw = FFYaw + 2*pi;
			else
				EFYaw = EFYaw + 2*pi;
			end
		end
		ErrA(k) = abs(EFYaw - FFYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'FYaw error', ErrA);

	%
	% Test FYawOfFused
	%

	% Begin test
	N = BeginTest('FYawOfFused', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (FYawOfFused([0 0 0 1]) == 0);
	for k = 1:N
		Fr = RandFused;
		B = B && (FYawOfFused(Fr) == Fr(1));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test FYawOfQuat
	%

	% Begin test
	[N, ErrA] = BeginTest('FYawOfQuat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (FYawOfQuat([1 0 0 0]) == 0);

	% Perform the required testing
	for k = 1:N
		Qr = RandQuat;
		Fr = FusedFromQuat(Qr);
		QFYaw = FYawOfQuat(Qr);
		FFYaw = Fr(1);
		if abs(QFYaw-FFYaw) > pi
			if QFYaw > FFYaw
				FFYaw = FFYaw + 2*pi;
			else
				QFYaw = QFYaw + 2*pi;
			end
		end
		ErrA(k) = abs(QFYaw - FFYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'FYaw error', ErrA);

	%
	% Test FYawOfRotmat
	%

	% Begin test
	[N, ErrA] = BeginTest('FYawOfRotmat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (FYawOfRotmat(eye(3)) == 0);

	% Perform the required testing
	for k = 1:N
		Rr = RandRotmat;
		Fr = FusedFromRotmat(Rr);
		RFYaw = FYawOfRotmat(Rr);
		FFYaw = Fr(1);
		if abs(RFYaw-FFYaw) > pi
			if RFYaw > FFYaw
				FFYaw = FFYaw + 2*pi;
			else
				RFYaw = RFYaw + 2*pi;
			end
		end
		ErrA(k) = abs(RFYaw - FFYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'FYaw error', ErrA);

	%
	% Test FYawOfTilt
	%

	% Begin test
	[N, ErrA] = BeginTest('FYawOfTilt', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	B = B && (FYawOfTilt([0 0 0]) == 0);

	% Perform the required testing
	for k = 1:N
		Tr = RandTilt;
		Fr = FusedFromTilt(Tr);
		TFYaw = FYawOfTilt(Tr);
		FFYaw = Fr(1);
		if abs(TFYaw-FFYaw) > pi
			if TFYaw > FFYaw
				FFYaw = FFYaw + 2*pi;
			else
				TFYaw = TFYaw + 2*pi;
			end
		end
		ErrA(k) = abs(TFYaw - FFYaw);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'FYaw error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFYawOf', P);

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