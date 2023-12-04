% TestRand.m - Philipp Allgeuer - 05/11/14
% Tests:   Rand*, RandAng, RandVec, RandUnitVec
% Assumes: None
%
% function [Pass] = TestRand(N, Tol, Inter)
%
% This script outputs many manual comparisons that can be further manually
% checked by the testing human if desired. In each case the expected value
% is displayed next to an actual value, and they should be 'close' to each
% other. How close the values can be expected to be is in proportion to the
% number of test cases used, and thus difficult to computationally quantify.
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestRand(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 10000;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end
	if nargin < 3
		Inter = false;
	end

	% Begin test script
	[P, Nnormal, ~, ~, Ntiny] = BeginTestScript('TestRand', N, Tol);

	%
	% Test RandEuler
	%

	% Begin test
	N = BeginTest('RandEuler', Nnormal);
	B = BeginBoolean();

	% Generate a set of random rotations
	D = RandEuler(N);

	% Range checking
	B = TestRanges(B, D, N, 3, [-pi -pi/2 -pi], [pi pi/2 pi]);

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RandFused
	%

	% Begin test
	N = BeginTest('RandFused', Nnormal);
	B = BeginBoolean();

	% Generate a set of random rotations
	D = RandFused(N);

	% Range checking
	B = TestRanges(B, D, N, 4, [-pi -pi/2 -pi/2 -1], [pi pi/2 pi/2 1]);
	B = B && all((D(:,4) == 1) | (D(:,4) == -1));

	% Test the validity criterion
	crit = sin(D(:,2)).^2 + sin(D(:,3)).^2;
	B = B && all(crit >= 0.0) && all(crit <= 1.0);

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RandQuat
	%

	% Begin test
	[N, ErrA] = BeginTest('RandQuat', Nnormal);
	B = BeginBoolean();

	% Generate a set of random rotations
	D = RandQuat(N);

	% Range checking
	B = TestRanges(B, D, N, 4, -ones(1,4), ones(1,4));

	% Check the quaternion norm
	ErrA = sqrt(D(:,1).^2 + D(:,2).^2 + D(:,3).^2 + D(:,4).^2) - 1.0;

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Unit norm', ErrA);

	%
	% Test RandRotmat
	%

	% Begin test
	[N, ErrA] = BeginTest('RandRotmat', Ntiny);
	B = BeginBoolean();

	% Generate a set of random rotations
	R = RandRotmat(N);
	D = zeros(N,9);
	for k = 1:N
		Tmp = R(:,:,k);
		D(k,:) = Tmp(:)';
	end

	% Range checking
	B = TestRanges(B, D, N, 9, -ones(1,9), ones(1,9));

	% Check that the rotation matrices are valid by re-orthogonalising them and seeing if they stay the same
	for k = 1:N
		T = R(:,:,k);
		U = T/sqrtm(T'*T);
		ErrA(k) = norm(U - T);
	end

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Orthogonality', ErrA);

	%
	% Test RandTilt
	%

	% Begin test
	N = BeginTest('RandTilt', Nnormal);
	B = BeginBoolean();

	% Generate a set of random rotations
	D = RandTilt(N);

	% Range checking
	B = TestRanges(B, D, N, 3, [-pi -pi 0], [pi pi pi]);

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RandAng
	%

	% Begin test
	N = BeginTest('RandAng', Nnormal);
	B = BeginBoolean();

	% Generate random vectors
	A = [RandAng(N) RandAng(N,pi/2) RandAng(N,[-1 0.5])];

	% Range checking
	B = TestRanges(B, A, N, 3, [-pi 0 -1], [pi pi/2 0.5]);

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RandVec
	%

	% Begin test
	N = BeginTest('RandVec', Nnormal);
	B = BeginBoolean();

	% Generate random vectors
	V = RandVec(N, 3.0);

	% Range checking
	B = TestRanges(B, V', N, 3, [-3 -3 -3], [3 3 3]);

	% Check the vector 2-norm is in range
	Mag = sqrt(V(1,:).^2 + V(2,:).^2 + V(3,:).^2);
	B = B && all(Mag >= 0) && all(Mag <= 3);

	% Human checking
	fprintf('Min mag:   0.0 => %.3g\n'  , min(Mag));
	fprintf('Mean mag:  1.5 => %.3g\n'  , mean(Mag));
	fprintf('Max mag:   3.0 => %.3g\n\n', max(Mag));

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest();

	%
	% Test RandUnitVec
	%

	% Begin test
	[N, MagErr] = BeginTest('RandUnitVec', Nnormal);
	B = BeginBoolean();

	% Generate random vectors
	V = RandUnitVec(N, 5);

	% Range checking
	B = TestRanges(B, V', N, 5, -ones(1,5), ones(1,5));

	% Check the vector 2-norm
	Mag = sqrt(sum(V.^2,1));
	MagErr = abs(Mag - 1)';

	% End test
	P = P & EndBoolean(B);
	P = P & EndTest(Tol, 'Magnitude error', MagErr);

	%
	% Interactive testing
	%

	% Run the interactive testing component
	if Inter
		BeginTest('Interactive');
		B = BeginBoolean();
		B = B && TestRandInter();
		P = P & EndBoolean(B);
		P = P & EndTest();
	end

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestRand', P);

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

% Interactive testing component
function [B] = TestRandInter()

	% Initialise variables
	B = true;
	h = [];

	% Rand fused angle plots
	D = RandFused(10000);

	% Fused yaw plot
	h = [h figure()];
	hist(D(:,1),30);
	title('RandFused: Fused yaw');
	xlabel('Fused yaw');
	ylabel('Count');
	grid on;

	% Fused roll/pitch plot
	h = [h figure()];
	plot(D(:,2),D(:,3),'b.');
	title('RandFused: Fused roll vs fused pitch');
	xlabel('Fused pitch');
	ylabel('Fused roll');
	grid on;

	% Wait for the user to appreciate the interactive testing
	fprintf('Press enter to close any opened figures and continue...');
	pause;
	fprintf('\n');
	for f = h
		if ishandle(f)
			close(f);
		end
	end
	pause(0.3);

end

% Function to test ranges
function [B] = TestRanges(B, D, N, ElemSize, LBnd, UBnd)

	% Decide on an acceptable actual/expected proximity factor given the number of samples N
	Fact = min(max(1500/N,0.01),1);

	% Calculate the actual and expected bounds
	actmin = min(D);
	expmin = LBnd;
	actmax = max(D);
	expmax = UBnd;
	actmean = mean(D);
	expmean = 0.5*(LBnd+UBnd);
	expdiff = expmax - expmin;

	% Boolean conditions
	B = B && all(size(D) == [N ElemSize]);
	B = B && all(all(D >= repmat(expmin,N,1))) && all(all(D <= repmat(expmax,N,1)));
	B = B && all(actmin <= expmin + Fact*expdiff);
	B = B && all(actmax >= expmax - Fact*expdiff);
	B = B && all(actmean >= expmean - 2*Fact*expdiff) && all(actmean <= expmean + 2*Fact*expdiff);

	% Human checking
	fprintf('Minimums:   %s\n'  ,sprintf('%10.4g ',actmin));
	fprintf('Should be:  %s\n\n',sprintf('%10.4g ',expmin));
	fprintf('Means:      %s\n'  ,sprintf('%10.4g ',actmean));
	fprintf('Should be:  %s\n\n',sprintf('%10.4g ',expmean));
	fprintf('Maximums:   %s\n'  ,sprintf('%10.4g ',actmax));
	fprintf('Should be:  %s\n\n',sprintf('%10.4g ',expmax));

end
% EOF