% TestFromFYawTilt.m - Philipp Allgeuer - 05/05/17
% Tests:   *FromFYawTilt
% Assumes: RandTilt, RandQuat, QuatFromTilt, QuatEqual, QuatMult, FYawOfQuat, QuatNoFYaw
%
% function [Pass] = TestFromFYawTilt(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestFromFYawTilt(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 3000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestFromFYawTilt', N, Tol);

	%
	% Test QuatFromFYawTilt
	%

	% Begin test
	[N, ErrA, ErrB, ErrC] = BeginTest('QuatFromFYawTilt', Nnormal, [3 3 3]);

	% Perform the required testing
	for k = 1:N
		FYawG = 4*pi*(2*rand - 1);
		TiltH1 = RandTilt;
		TiltH2 = TiltH1(2:3);
		TiltH3 = QuatFromTilt(TiltH1);
		qGH = RandQuat;

		[qHB1, qGB1] = QuatFromFYawTilt(FYawG, TiltH1, qGH);
		[qHB2, qGB2] = QuatFromFYawTilt(FYawG, TiltH2, qGH);
		[qHB3, qGB3] = QuatFromFYawTilt(FYawG, TiltH3, qGH);

		[~, ErrA(k,1)] = QuatEqual(QuatMult(qGH, qHB1), qGB1);
		[~, ErrA(k,2)] = QuatEqual(QuatMult(qGH, qHB2), qGB2);
		[~, ErrA(k,3)] = QuatEqual(QuatMult(qGH, qHB3), qGB3);

		ErrB(k,1) = norm(pi - mod(pi - (FYawOfQuat(qGB1) - FYawG), 2*pi));
		ErrB(k,2) = norm(pi - mod(pi - (FYawOfQuat(qGB2) - FYawG), 2*pi));
		ErrB(k,3) = norm(pi - mod(pi - (FYawOfQuat(qGB3) - FYawG), 2*pi));

		qRef = QuatFromTilt([0 TiltH2]);
		[~, ErrC(k,1)] = QuatEqual(QuatNoFYaw(qHB1), qRef);
		[~, ErrC(k,2)] = QuatEqual(QuatNoFYaw(qHB2), qRef);
		[~, ErrC(k,3)] = QuatEqual(QuatNoFYaw(qHB3), qRef);
	end

	% End test
	fprintf('Using special tolerance %g for error testing.\n\n', 1.5e-8);
	P = P & EndTest(1.5e-8, 'Self-consistency', ErrA, 'FYaw correct', ErrB, 'Tilt correct', ErrC);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestFromFYawTilt', P);

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