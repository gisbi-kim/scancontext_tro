% TestRotVec.m - Philipp Allgeuer - 05/11/14
% Tests:   *RotVec
% Assumes: Rand*, RandVec, RotmatFrom*
%
% function [Pass] = TestRotVec(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestRotVec(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 700;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestRotVec', N, Tol);

	%
	% Test EulerRotVec
	%

	% Begin test
	[N, ErrA] = BeginTest('EulerRotVec', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vin = RandVec(1,3);
		Er = RandEuler;
		Rr = RotmatFromEuler(Er);
		B = B && all(EulerRotVec(Er,[0 0 0]) == [0 0 0]);
		B = B && all(EulerRotVec(Er,[0;0;0]) == [0;0;0]);
		ErrA(k) = norm(EulerRotVec(Er,Vin) - Rr*Vin);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotated vector norm error', ErrA);

	%
	% Test FusedRotVec
	%

	% Begin test
	[N, ErrA] = BeginTest('FusedRotVec', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vin = RandVec(1,3);
		Fr = RandFused;
		Rr = RotmatFromFused(Fr);
		B = B && all(FusedRotVec(Fr,[0 0 0]) == [0 0 0]);
		B = B && all(FusedRotVec(Fr,[0;0;0]) == [0;0;0]);
		ErrA(k) = norm(FusedRotVec(Fr,Vin) - Rr*Vin);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotated vector norm error', ErrA);

	%
	% Test QuatRotVec
	%

	% Begin test
	[N, ErrA] = BeginTest('QuatRotVec', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vin = RandVec(1,3);
		Qr = RandQuat;
		Rr = RotmatFromQuat(Qr);
		B = B && all(QuatRotVec(Qr,[0 0 0]) == [0 0 0]);
		B = B && all(QuatRotVec(Qr,[0;0;0]) == [0;0;0]);
		ErrA(k) = norm(QuatRotVec(Qr,Vin) - Rr*Vin);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotated vector norm error', ErrA);

	%
	% Test RotmatRotVec
	%

	% Begin test
	[N, ErrA] = BeginTest('RotmatRotVec', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vin = RandVec(1,3);
		Rr = RandRotmat;
		B = B && all(RotmatRotVec(Rr,[0 0 0]) == [0 0 0]);
		B = B && all(RotmatRotVec(Rr,[0;0;0]) == [0;0;0]);
		ErrA(k) = norm(RotmatRotVec(Rr,Vin) - Rr*Vin);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotated vector norm error', ErrA);

	%
	% Test TiltRotVec
	%

	% Begin test
	[N, ErrA] = BeginTest('TiltRotVec', Nnormal);
	B = BeginBoolean();

	% Perform the required testing
	for k = 1:N
		Vin = RandVec(1,3);
		Tr = RandTilt;
		Rr = RotmatFromTilt(Tr);
		B = B && all(TiltRotVec(Tr,[0 0 0]) == [0 0 0]);
		B = B && all(TiltRotVec(Tr,[0;0;0]) == [0;0;0]);
		ErrA(k) = norm(TiltRotVec(Tr,Vin) - Rr*Vin);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Rotated vector norm error', ErrA);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestRotVec', P);

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