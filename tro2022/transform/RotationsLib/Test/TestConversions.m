% TestConversions.m - Philipp Allgeuer - 05/11/14
% Tests:   *From*
% Assumes: Rand*, *Equal
%
% function [Pass] = TestConversions(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestConversions(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 250;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestConversions', N, Tol);

	%
	% Test 2-conversions
	%

	% Begin test
	N = BeginTest('2-conversions', Nnormal);
	B = BeginBoolean();

	% Initialise the error vectors
	ErrA = zeros(N,4);
	ErrB = zeros(N,4);
	ErrC = zeros(N,4);
	ErrD = zeros(N,4);
	ErrE = zeros(N,4);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
 		%[~, ErrA(k,1)] = EulerEqual(Er, EulerFromFused(FusedFromEuler(Er))); % Note: Extremely near Euler gimbal lock EulerFromFused becomes quite sensitive to noise, unavoidably producing errors up to 1e-6 in this 2-conversion.
		[~, ErrA(k,2)] = EulerEqual(Er, EulerFromQuat(QuatFromEuler(Er)));
		[~, ErrA(k,3)] = EulerEqual(Er, EulerFromRotmat(RotmatFromEuler(Er)));
		[~, ErrA(k,4)] = EulerEqual(Er, EulerFromTilt(TiltFromEuler(Er)));
		Fr = RandFused;
		[~, ErrB(k,1)] = FusedEqual(Fr, FusedFromEuler(EulerFromFused(Fr)));
		[~, ErrB(k,2)] = FusedEqual(Fr, FusedFromQuat(QuatFromFused(Fr)));
		[~, ErrB(k,3)] = FusedEqual(Fr, FusedFromRotmat(RotmatFromFused(Fr)));
		[~, ErrB(k,4)] = FusedEqual(Fr, FusedFromTilt(TiltFromFused(Fr)));
		Qr = RandQuat;
		[~, ErrC(k,1)] = QuatEqual(Qr, QuatFromEuler(EulerFromQuat(Qr)));
		[~, ErrC(k,2)] = QuatEqual(Qr, QuatFromFused(FusedFromQuat(Qr)));
		[~, ErrC(k,3)] = QuatEqual(Qr, QuatFromRotmat(RotmatFromQuat(Qr)));
		[~, ErrC(k,4)] = QuatEqual(Qr, QuatFromTilt(TiltFromQuat(Qr)));
		Rr = RandRotmat;
		[~, ErrD(k,1)] = RotmatEqual(Rr, RotmatFromEuler(EulerFromRotmat(Rr)));
		[~, ErrD(k,2)] = RotmatEqual(Rr, RotmatFromFused(FusedFromRotmat(Rr)));
		[~, ErrD(k,3)] = RotmatEqual(Rr, RotmatFromQuat(QuatFromRotmat(Rr)));
		[~, ErrD(k,4)] = RotmatEqual(Rr, RotmatFromTilt(TiltFromRotmat(Rr)));
		Tr = RandTilt;
		[~, ErrE(k,1)] = TiltEqual(Tr, TiltFromEuler(EulerFromTilt(Tr)));
		[~, ErrE(k,2)] = TiltEqual(Tr, TiltFromFused(FusedFromTilt(Tr)));
		[~, ErrE(k,3)] = TiltEqual(Tr, TiltFromQuat(QuatFromTilt(Tr)));
		[~, ErrE(k,4)] = TiltEqual(Tr, TiltFromRotmat(RotmatFromTilt(Tr)));
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Euler 2-conversions', ErrA, 'Fused 2-conversions', ErrB, 'Quat 2-conversions', ErrC, 'Rotmat 2-conversions', ErrD, 'Tilt 2-conversions', ErrE);

	%
	% Test 3-conversions
	%

	% Begin test
	N = BeginTest('3-conversions', Nnormal);
	B = BeginBoolean();

	% Initialise the error vectors
	ErrA = zeros(N,3);
	ErrB = zeros(N,3);
	ErrC = zeros(N,3);
	ErrD = zeros(N,3);
	ErrE = zeros(N,3);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
		QEr = QuatFromEuler(Er);
		[~, ErrA(k,1)] = QuatEqual(QuatFromFused(FusedFromEuler(Er)), QEr);
		[~, ErrA(k,2)] = QuatEqual(QuatFromRotmat(RotmatFromEuler(Er)), QEr);
		[~, ErrA(k,3)] = QuatEqual(QuatFromTilt(TiltFromEuler(Er)), QEr);

		Fr = RandFused;
		RFr = RotmatFromFused(Fr);
		[~, ErrB(k,1)] = RotmatEqual(RotmatFromEuler(EulerFromFused(Fr)), RFr);
		[~, ErrB(k,2)] = RotmatEqual(RotmatFromQuat(QuatFromFused(Fr)), RFr);
		[~, ErrB(k,3)] = RotmatEqual(RotmatFromTilt(TiltFromFused(Fr)), RFr);

		Qr = RandQuat;
		TQr = TiltFromQuat(Qr);
		[~, ErrC(k,1)] = TiltEqual(TiltFromEuler(EulerFromQuat(Qr)), TQr);
		[~, ErrC(k,2)] = TiltEqual(TiltFromFused(FusedFromQuat(Qr)), TQr);
		[~, ErrC(k,3)] = TiltEqual(TiltFromRotmat(RotmatFromQuat(Qr)), TQr);

		Rr = RandRotmat;
		ERr = EulerFromRotmat(Rr);
% 		[~, ErrD(k,1)] = EulerEqual(EulerFromFused(FusedFromRotmat(Rr)), ERr); % Note: The EulerFromFused function is sensitive to noise very near gimbal lock and infrequently gives errors in excess of 1e-10.
		[~, ErrD(k,2)] = EulerEqual(EulerFromQuat(QuatFromRotmat(Rr)), ERr);
		[~, ErrD(k,3)] = EulerEqual(EulerFromTilt(TiltFromRotmat(Rr)), ERr);

		Tr = RandTilt;
		FTr = FusedFromTilt(Tr);
		[~, ErrE(k,1)] = FusedEqual(FusedFromEuler(EulerFromTilt(Tr)), FTr);
		[~, ErrE(k,2)] = FusedEqual(FusedFromQuat(QuatFromTilt(Tr)), FTr);
		[~, ErrE(k,3)] = FusedEqual(FusedFromRotmat(RotmatFromTilt(Tr)), FTr);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndBoolean(B);
	P = P & EndTest(1.5e-8, 'Euler-Quat 3-conversions', ErrA, 'Fused-Rotmat 3-conversions', ErrB, 'Quat-Tilt 3-conversions', ErrC, 'Rotmat-Euler 3-conversions', ErrD, 'Tilt-Fused 3-conversions', ErrE);

	%
	% Test additional outputs
	%

	% Begin test
	N = BeginTest('Additional outputs', Nnormal);
	B = BeginBoolean();

	% Initialise the error vectors
	ErrA = zeros(N,4);
	ErrB = zeros(N,4);

	% Perform the required testing
	for k = 1:N
		Er = RandEuler;
		Fr = RandFused;
		Qr = RandQuat;
		Rr = RandRotmat;

		TFr = TiltFromFused(Fr);
		[~, Tilt] = EulerFromFused(Fr);
		[~, ErrA(k,1)] = TiltEqual(Tilt, TFr);
		[~, Tilt] = QuatFromFused(Fr);
		[~, ErrA(k,2)] = TiltEqual(Tilt, TFr);
		[~, Tilt] = RotmatFromFused(Fr);
		[~, ErrA(k,3)] = TiltEqual(Tilt, TFr);

		REr = RotmatFromEuler(Er);
		[~, Rotmat] = TiltFromEuler(Er);
		[~, ErrA(k,4)] = RotmatEqual(Rotmat, REr);

		REr = RotmatFromEuler(Er);
		TEr = TiltFromEuler(Er);
		[~, Rotmat, Tilt] = FusedFromEuler(Er);
		[~, ErrB(k,1)] = RotmatEqual(Rotmat, REr);
		[~, ErrB(k,2)] = TiltEqual(Tilt, TEr);

		TQr = TiltFromQuat(Qr);
		[~, Tilt] = FusedFromQuat(Qr);
		[~, ErrB(k,3)] = TiltEqual(Tilt, TQr);

		TRr = TiltFromRotmat(Rr);
		[~, Tilt] = FusedFromRotmat(Rr);
		[~, ErrB(k,4)] = TiltEqual(Tilt, TRr);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Group 1', ErrA, 'Group 2', ErrB);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestConversions', P);

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