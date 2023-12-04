% TestSlerp.m - Philipp Allgeuer - 31/10/16
% Tests:   QuatSlerp
% Assumes: RandQuat, ComposeQuat, QuatInv
%
% function [Pass] = TestSlerp(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestSlerp(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 200;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	[P, Nnormal] = BeginTestScript('TestSlerp', N, Tol);

	%
	% Test QuatSlerp
	%

	% Begin test
	[N, ErrA, ErrB, ErrC, ErrD] = BeginTest('QuatSlerp', Nnormal, [5 2 3 1]);
	B = BeginBoolean();

	% Boolean conditions
	B = B && all(QuatSlerp([cos(0.1) sin(0.1) 0 0], [cos(0.1) -sin(0.1) 0 0], 0.5) == [1 0 0 0]);
	B = B && all(QuatSlerp([cos(0.2) 0 sin(0.2) 0], [-cos(0.2) 0 sin(0.2) 0], 0.5) == [1 0 0 0]);
	B = B && all(QuatSlerp([cos(0.3) 0 0 sin(0.3)], [cos(0.3) 0 0 -sin(0.3)], 0.5) == [1 0 0 0]);

	% Perform the required testing
	for k = 1:N
		qa = RandQuat;
		qb = RandQuat;

		qout = [QuatSlerp(qa, qb, 0.0); QuatSlerp(qa, qb, 0.25); QuatSlerp(qa, qb, 0.5); QuatSlerp(qa, qb, 0.75); QuatSlerp(qa, qb, 1.0)];
		dqout = [ComposeQuat(qout(2,:), QuatInv(qout(1,:))); ComposeQuat(qout(3,:), QuatInv(qout(2,:))); ComposeQuat(qout(4,:), QuatInv(qout(3,:))); ComposeQuat(qout(5,:), QuatInv(qout(4,:)))];

		ErrA(k,1) = norm(QuatSlerp(qa, qa, 0.0) - qa);
		ErrA(k,2) = norm(QuatSlerp(qa, qa, 0.5) - qa);
		ErrA(k,3) = norm(QuatSlerp(qa, qa, 1.0) - qa);

		if qout(1,1)*qa(1) >= 0
			ErrB(k,1) = norm(qout(1,:) - qa);
		else
			ErrB(k,1) = norm(qout(1,:) + qa);
		end
		if qout(5,1)*qb(1) >= 0
			ErrB(k,2) = norm(qout(5,:) - qb);
		else
			ErrB(k,2) = norm(qout(5,:) + qb);
		end

		ErrC(k,1) = norm(dqout(1,:) - dqout(2,:));
		ErrC(k,2) = norm(dqout(2,:) - dqout(3,:));
		ErrC(k,3) = norm(dqout(3,:) - dqout(4,:));

		total = ComposeQuat(dqout(1,:), dqout(2,:), dqout(3,:), dqout(4,:), qa);
		if total(1)*qb(1) >= 0
			ErrD(k,4) = norm(total - qb);
		else
			ErrD(k,4) = norm(total + qb);
		end
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Trivial slerp', ErrA, 'Slerp endpoints', ErrB, 'Slerp linearity', ErrC, 'Slerp total', ErrD);

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestSlerp', P);

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