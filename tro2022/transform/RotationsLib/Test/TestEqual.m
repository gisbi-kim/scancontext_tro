% TestEqual.m - Philipp Allgeuer - 05/11/14
% Tests:   *Equal, Ensure*
% Assumes: Rand*
%
% function [Pass] = TestEqual(N, Tol, Inter)
%
% The fact that *Equal (EFT) is correct means that Ensure* (EFT) is also correct,
% as the former is based on the latter (assumed). Thus to assert that Ensure*
% is correct we only need to additionally check Ensure* (QR).
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestEqual(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 600;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestEqual', N, Tol);

	%
	% Test EulerEqual
	%

	% Begin test
	N = BeginTest('EulerEqual', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Er = RandEuler;
	[Equal, Err] = EulerEqual(Er, Er, 0);
	B = B && Equal && (Err == 0);
	B = B && ~EulerEqual([1 0 0], [0 0 1], Tol);
	for k = 1:N
		Er = RandEuler;
		B = B && EulerEqual(Er, Er+2*pi*(randi(9,1,3)-5), Tol);
		B = B && EulerEqual(Er, [pi+Er(1) pi-Er(2) pi+Er(3)], Tol);
		B = B && EulerEqual([Er(1) pi/2 Er(3)], [0 pi/2 Er(3)-Er(1)+2*pi*(randi(9)-5)], Tol);
		B = B && EulerEqual([Er(1) -pi/2 Er(3)], [0 -pi/2 Er(3)+Er(1)+2*pi*(randi(9)-5)], Tol);
		B = B && EulerEqual([Er(1) asin(1) Er(3)], [Er(1) asin(1-0.49*Tol*rand) Er(3)], Tol);
		B = B && EulerEqual([Er(1) asin(-1) Er(3)], [Er(1) asin(-1+0.49*Tol*rand) Er(3)], Tol);
		B = B && ~EulerEqual(Er, Er+[1 0 2], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test FusedEqual
	%

	% Begin test
	N = BeginTest('FusedEqual', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Fr = RandFused;
	[Equal, Err] = FusedEqual(Fr, Fr, 0);
	B = B && Equal && (Err == 0);
	B = B && ~FusedEqual([1 0 0 1], [0 0 1 1], Tol);
	for k = 1:N
		Fr = RandFused;
		B = B && FusedEqual(Fr, Fr+[2*pi*(randi(9,1,3)-5) 0], Tol);
		Scale = (pi/2)/(abs(Fr(2))+abs(Fr(3)));
		B = B && FusedEqual([Fr(1) Fr(2:3)*Scale 1], [Fr(1) Fr(2:3)*Scale*(1+rand) -1], Tol);
		B = B && FusedEqual([Fr(1) 0.5*Tol*(2*rand(1,2)-1) -1],[Fr(1)+2*pi*rand 0.5*Tol*(2*rand(1,2)-1) -1], Tol);
		B = B && FusedEqual([Fr(1) asin(1) 0 Fr(4)], [Fr(1) asin(1-0.49*Tol*rand) 0 Fr(4)], Tol);
		B = B && FusedEqual([Fr(1) 0 asin(1) Fr(4)], [Fr(1) 0 asin(1-0.49*Tol*rand) Fr(4)], Tol);
		B = B && FusedEqual([Fr(1) asin(-1) 0 Fr(4)], [Fr(1) asin(-1+0.49*Tol*rand) 0 Fr(4)], Tol);
		B = B && FusedEqual([Fr(1) 0 asin(-1) Fr(4)], [Fr(1) 0 asin(-1+0.49*Tol*rand) Fr(4)], Tol);
		B = B && ~FusedEqual(Fr, Fr+[2 1 0 0], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test QuatEqual
	%

	% Begin test
	N = BeginTest('QuatEqual', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Qr = RandQuat;
	[Equal, Err] = QuatEqual(Qr, Qr, 0);
	B = B && Equal && (Err == 0);
	B = B && ~QuatEqual([0 1 0 0], [0 0 1 0], Tol);
	for k = 1:N
		Qr = RandQuat;
		[Equal, Err] = QuatEqual(Qr, -Qr, 0);
		B = B && Equal && (Err == 0);
		if Qr(1) > 0.01 && Qr(1) < 0.99
			B = B && ~QuatEqual(Qr, [Qr(1) -Qr(2:4)], Tol);
		end
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test RotmatEqual
	%

	% Begin test
	N = BeginTest('RotmatEqual', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Rr = RandRotmat;
	[Equal, Err] = RotmatEqual(Rr, Rr, 0);
	B = B && Equal && (Err == 0);
	B = B && ~RotmatEqual([0 1 0;1 0 0;0 0 -1], eye(3), Tol);
	for k = 1:N
		Rr = RandRotmat;
		B = B &&  RotmatEqual(Rr, Rr+Tol*(2*rand(3,3)-1), Tol);
		B = B && ~RotmatEqual(Rr, Rr+1.1*(Tol./(2*rand(3,3)-1)), Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test TiltEqual
	%

	% Begin test
	N = BeginTest('TiltEqual', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	Tr = RandTilt;
	[Equal, Err] = TiltEqual(Tr, Tr, 0);
	B = B && Equal && (Err == 0);
	B = B && ~TiltEqual([1 0 0.5], [0 0 1], Tol);
	for k = 1:N
		Tr = RandTilt;
		B = B && TiltEqual(Tr, Tr+2*pi*(randi(9,1,3)-5), Tol);
		B = B && TiltEqual(Tr, [Tr(1) Tr(2)+pi -Tr(3)], Tol);
		B = B && TiltEqual([Tr(1:2) acos(1)], [Tr(1:2) acos(1-0.49*Tol*rand)], Tol);
		B = B && TiltEqual([Tr(1:2) acos(-1)], [Tr(1:2) acos(-1+0.49*Tol*rand)], Tol);
		B = B && ~TiltEqual(Tr, Tr+[1 0 2], Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test EnsureQuat
	%

	% Begin test
	N = BeginTest('EnsureQuat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	[Qout, WasBad, Norm] = EnsureQuat([1 0 0 0], 0, true);
	B = B && all(Qout == [1 0 0 0]) && ~WasBad && (Norm == 1);
	B = B && all(EnsureQuat([0 0 0 0], Tol, true) == [1 0 0 0]);
	for k = 1:N
		Qr = RandQuat;
		[Qout, WasBad, Norm] = EnsureQuat(Qr, Tol, true);
		B = B && ((WasBad && all(abs(Qr + Qout) <= Tol)) || (~WasBad && all(abs(Qr - Qout) <= Tol)));
		B = B && (abs(Norm - 1) <= Tol);
		Mag = 2*rand+1.1;
		[Qout, WasBad, Norm] = EnsureQuat(Mag*Qr, Tol, false);
		B = B && all(abs(Qout - Qr) <= Tol) && WasBad && (abs(Norm - Mag) <= Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% Test EnsureRotmat
	%

	% Begin test
	N = BeginTest('EnsureRotmat', Nnormal);
	B = BeginBoolean();

	% Boolean conditions
	[~, WasBad] = EnsureRotmat([1 0 0.1;0 1 0;0 0 1], Tol);
	B = B && WasBad;
	[Rout, WasBad] = EnsureRotmat(eye(3), 0);
	B = B && all(all(Rout == eye(3))) && ~WasBad;
	for k = 1:N
		Rr = RandRotmat;
		[Rout, WasBad] = EnsureRotmat(Rr, Tol);
		B = B && all(all(abs(Rout - Rr) <= Tol)) && ~WasBad;
		Rnew = EnsureRotmat(Rr+0.1*(2*rand(3)-1), Tol);
		B = B && (abs(det(Rr)-1) <= Tol);
		B = B && all(all(abs(Rnew*Rnew'-eye(3)) <= Tol));
		B = B && all(all(abs(Rnew'*Rnew-eye(3)) <= Tol));
		B = B && all(abs(cross(Rnew(:,1),Rnew(:,2)) - Rnew(:,3)) <= Tol);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestEqual', P);

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