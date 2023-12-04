% TestCompose.m - Philipp Allgeuer - 05/11/14
% Tests:   Compose*
% Assumes: Rand*, *Equal, RotmatFrom*, *FromRotmat
%
% function [Pass] = TestCompose(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestCompose(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 500;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestCompose', N, Tol);

	%
	% Test ComposeEuler
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('ComposeEuler', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Er = RandEuler(2);
	B = B && all(ComposeEuler() == [0 0 0]);
	B = B && all(ComposeEuler(Er(1,:)) == Er(1,:));
	B = B && all(ComposeEuler(Er(2,:)) == Er(2,:));

	% Calculate composition errors
	for k = 1:N
		Er = RandEuler(3);
		REa = RotmatFromEuler(Er(1,:));
		REb = RotmatFromEuler(Er(2,:));
		REc = RotmatFromEuler(Er(3,:));
		[~, ErrA(k)] = EulerEqual(ComposeEuler(Er(1,:),Er(2,:)), EulerFromRotmat(REa*REb));
		[~, ErrB(k)] = EulerEqual(ComposeEuler(Er(1,:),Er(2,:),Er(3,:)), EulerFromRotmat(REa*REb*REc));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, '2 arguments', ErrA, '3 arguments', ErrB);

	%
	% Test ComposeFused
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('ComposeFused', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Fr = RandFused(2);
	B = B && all(ComposeFused() == [0 0 0 1]);
	B = B && all(ComposeFused(Fr(1,:)) == Fr(1,:));
	B = B && all(ComposeFused(Fr(2,:)) == Fr(2,:));

	% Calculate composition errors
	for k = 1:N
		Fr = RandFused(3);
		RFa = RotmatFromFused(Fr(1,:));
		RFb = RotmatFromFused(Fr(2,:));
		RFc = RotmatFromFused(Fr(3,:));
		[~, ErrA(k)] = FusedEqual(ComposeFused(Fr(1,:),Fr(2,:)), FusedFromRotmat(RFa*RFb));
		[~, ErrB(k)] = FusedEqual(ComposeFused(Fr(1,:),Fr(2,:),Fr(3,:)), FusedFromRotmat(RFa*RFb*RFc));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, '2 arguments', ErrA, '3 arguments', ErrB);

	%
	% Test ComposeQuat
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('ComposeQuat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Qr = RandQuat(2);
	B = B && all(ComposeQuat() == [1 0 0 0]);
	B = B && all(ComposeQuat(Qr(1,:)) == Qr(1,:));
	B = B && all(ComposeQuat(Qr(2,:)) == Qr(2,:));

	% Calculate composition errors
	for k = 1:N
		Qr = RandQuat(3);
		RQa = RotmatFromQuat(Qr(1,:));
		RQb = RotmatFromQuat(Qr(2,:));
		RQc = RotmatFromQuat(Qr(3,:));
		[~, ErrA(k)] = QuatEqual(ComposeQuat(Qr(1,:),Qr(2,:)), QuatFromRotmat(RQa*RQb));
		[~, ErrB(k)] = QuatEqual(ComposeQuat(Qr(1,:),Qr(2,:),Qr(3,:)), QuatFromRotmat(RQa*RQb*RQc));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, '2 arguments', ErrA, '3 arguments', ErrB);

	%
	% Test ComposeRotmat
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('ComposeRotmat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Rr = RandRotmat(2);
	B = B && all(all(ComposeRotmat() == eye(3)));
	B = B && all(all(ComposeRotmat(Rr(:,:,1)) == Rr(:,:,1)));
	B = B && all(all(ComposeRotmat(Rr(:,:,2)) == Rr(:,:,2)));

	% Calculate composition errors
	for k = 1:N
		Rr = RandRotmat(3);
		[~, ErrA(k)] = RotmatEqual(ComposeRotmat(Rr(:,:,1),Rr(:,:,2)), Rr(:,:,1)*Rr(:,:,2));
		[~, ErrB(k)] = RotmatEqual(ComposeRotmat(Rr(:,:,1),Rr(:,:,2),Rr(:,:,3)), Rr(:,:,1)*Rr(:,:,2)*Rr(:,:,3));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, '2 arguments', ErrA, '3 arguments', ErrB);

	%
	% Test ComposeTilt
	%

	% Begin test
	[N, ErrA, ErrB] = BeginTest('ComposeTilt', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Tr = RandTilt(2);
	B = B && all(ComposeTilt() == [0 0 0]);
	B = B && all(ComposeTilt(Tr(1,:)) == Tr(1,:));
	B = B && all(ComposeTilt(Tr(2,:)) == Tr(2,:));

	% Calculate composition errors
	for k = 1:N
		Tr = RandTilt(3);
		RTa = RotmatFromTilt(Tr(1,:));
		RTb = RotmatFromTilt(Tr(2,:));
		RTc = RotmatFromTilt(Tr(3,:));
		[~, ErrA(k)] = TiltEqual(ComposeTilt(Tr(1,:),Tr(2,:)), TiltFromRotmat(RTa*RTb));
		[~, ErrB(k)] = TiltEqual(ComposeTilt(Tr(1,:),Tr(2,:),Tr(3,:)), TiltFromRotmat(RTa*RTb*RTc));
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, '2 arguments', ErrA, '3 arguments', ErrB);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestCompose', P);

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