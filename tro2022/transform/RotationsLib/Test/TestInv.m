% TestInv.m - Philipp Allgeuer - 05/11/14
% Tests:   *Inv
% Assumes: Rand*, QuatFrom*, Compose*, *Equal
%
% function [Pass] = TestInv(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestInv(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 1000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestInv', N, Tol);

	%
	% Test EulerInv
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('EulerInv', Nnormal);
	B = BeginBoolean();

	% Set the identity
	Ident = [0 0 0];

	% Boolean conditions
	B = B && EulerEqual(EulerInv(Ident), Ident, Tol);

	% Calculate inversion errors
	for k = 1:N
		Er = RandEuler;
		Erinv = EulerInv(Er);
		QEr = QuatFromEuler(Er);
		QErinv = QuatFromEuler(Erinv);
		[~, ErrA(k)] = QuatEqual(ComposeQuat(QEr,QErinv), [1 0 0 0], Tol);
		[~, ErrB(k)] = QuatEqual(ComposeQuat(QErinv,QEr), [1 0 0 0], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(4*Tol, 'Composition E*inv(E)', ErrA, 'Composition inv(E)*E', ErrB);

	%
	% Test FusedInv
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('FusedInv', Nnormal);
	B = BeginBoolean();

	% Set the identity
	Ident = [0 0 0 1];

	% Boolean conditions
	B = B && FusedEqual(FusedInv(Ident), Ident, Tol);

	% Calculate inversion errors
	for k = 1:N
		Fr = RandFused;
		Frinv = FusedInv(Fr);
		QFr = QuatFromFused(Fr);
		QFrinv = QuatFromFused(Frinv);
		[~, ErrA(k)] = QuatEqual(ComposeQuat(QFr,QFrinv), [1 0 0 0], Tol);
		[~, ErrB(k)] = QuatEqual(ComposeQuat(QFrinv,QFr), [1 0 0 0], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(4*Tol, 'Composition F*inv(F)', ErrA, 'Composition inv(F)*F', ErrB);

	%
	% Test QuatInv
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('QuatInv', Nnormal);
	B = BeginBoolean();

	% Set the identity
	Ident = [1 0 0 0];

	% Boolean conditions
	B = B && QuatEqual(QuatInv(Ident), Ident, Tol);

	% Calculate inversion errors
	for k = 1:N
		Qr = RandQuat;
		Qrinv = QuatInv(Qr);
		[~, ErrA(k)] = QuatEqual(ComposeQuat(Qr,Qrinv), Ident, Tol);
		[~, ErrB(k)] = QuatEqual(ComposeQuat(Qrinv,Qr), Ident, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Composition Q*inv(Q)', ErrA, 'Composition inv(Q)*Q', ErrB);

	%
	% Test RotmatInv
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('RotmatInv', Nnormal);
	B = BeginBoolean();

	% Set the identity
	Ident = eye(3);

	% Boolean conditions
	B = B && RotmatEqual(RotmatInv(Ident), Ident, Tol);

	% Calculate inversion errors
	for k = 1:N
		Rr = RandRotmat;
		Rrinv = RotmatInv(Rr);
		[~, ErrA(k)] = RotmatEqual(ComposeRotmat(Rr,Rrinv), Ident, Tol);
		[~, ErrB(k)] = RotmatEqual(ComposeRotmat(Rrinv,Rr), Ident, Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Composition R*inv(R)', ErrA, 'Composition inv(R)*R', ErrB);

	%
	% Test TiltInv
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('TiltInv', Nnormal);
	B = BeginBoolean();

	% Set the identity
	Ident = [0 0 0];

	% Boolean conditions
	B = B && TiltEqual(TiltInv(Ident), Ident, Tol);

	% Calculate inversion errors
	for k = 1:N
		Tr = RandTilt;
		Trinv = TiltInv(Tr);
		QTr = QuatFromTilt(Tr);
		QTrinv = QuatFromTilt(Trinv);
		[~, ErrA(k)] = QuatEqual(ComposeQuat(QTr,QTrinv), [1 0 0 0], Tol);
		[~, ErrB(k)] = QuatEqual(ComposeQuat(QTrinv,QTr), [1 0 0 0], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(4*Tol, 'Composition T*inv(T)', ErrA, 'Composition inv(T)*T', ErrB);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestInv', P);

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