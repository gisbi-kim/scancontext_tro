% RunAllTests.m - Philipp Allgeuer - 05/11/14
% Run all available/known test scripts of the Rotations Library.
%
% function [Pass] = RunAllTests(Speed, Inter)
%
% This function executes a collection of test scripts (e.g. TestRand, TestCompose, etc),
% each containing some number of individual tests. The number of test cases N used for
% each individual test script should be kept to a number such that, as a rule of thumb,
% each of the tests that constitute a test script take approximately 10s to execute in
% normal speed mode, or quicker if time is not a constraint in a particular test. If a
% test script fails then all remaining test scripts are still executed.
%
% Speed ==> One of 'Fast', 'Normal', 'Slow' or 'Ultraslow' (string)
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = RunAllTests(Speed, Inter)

	% Process input parameters
	if nargin < 1
		Speed = 'Normal';
	end
	if nargin < 2 || ~isscalar(Inter) || ~islogical(Inter)
		Inter = false;
	end

	% Process speed parameter
	switch lower(Speed)
		case 'fast'
			S = 1;
		case 'normal'
			S = 5;
		case 'slow'
			S = 20;
		case 'ultraslow'
			S = 50;
		case 'timewarpslow' % Intended for developer only...
			S = 500;
		otherwise
			error('Unrecognised speed parameter!');
	end

	% Print a header
	fprintf('######################################################################\n');
	fprintf('##################  Rotations Library => Run Tests  ##################\n');
	fprintf('######################################################################\n');
	fprintf('Speed: %s\n',Speed);
	if Inter
		fprintf('Interactive tests: True\n');
	else
		fprintf('Interactive tests: False\n');
	end
	fprintf('\n');

	% Initialise the pass flag
	P = true;

	% Error tolerances to choose from for each test script
	LTol = 2048*eps;
	MTol = 256*eps;
	HTol = 32*eps;

	% Retrieve the start time
	StartTime = tic;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Start of testing  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Tests:   *Identity
	% Assumes: None
	P = P & TestIdentity(1*S, HTol, Inter);

	% Tests:   Rand*, RandAng, RandVec, RandUnitVec
	% Assumes: None
	P = P & TestRand(10000*S, MTol, Inter);

	% Tests:   PlotCsys
	% Assumes: Rand*
	P = P & TestPlotCsys(1*S, MTol, Inter);

	% Tests:   *Equal, Ensure*
	% Assumes: Rand*
	P = P & TestEqual(600*S, MTol, Inter);

	% Tests:   *From*
	% Assumes: Rand*, *Equal
	P = P & TestConversions(250*S, HTol, Inter);

	% Tests:   Compose*
	% Assumes: Rand*, *Equal, RotmatFrom*, *FromRotmat
	P = P & TestCompose(500*S, HTol, Inter);

	% Tests:   *FromAxis
	% Assumes: RandVec, RandAng, *Equal, *FromQuat
	P = P & TestFromAxis(600*S, MTol, Inter);

	% Tests:   *Inv
	% Assumes: Rand*, QuatFrom*, Compose*, *Equal
	P = P & TestInv(1000*S, LTol, Inter);

	% Tests:   QuatSlerp
	% Assumes: RandQuat, ComposeQuat, QuatInv
	P = P & TestSlerp(200*S, HTol, Inter);

	% Tests:   *NoEYaw
	% Assumes: Rand*, *Equal, EulerFrom*, RotmatFromQuat
	P = P & TestNoEYaw(1600*S, MTol, Inter);

	% Tests:   *NoFYaw
	% Assumes: Rand*, FusedEqual, FusedFrom*
	P = P & TestNoFYaw(1500*S, MTol, Inter);

	% Tests:   *RotVec
	% Assumes: Rand*, RandVec, RotmatFrom*
	P = P & TestRotVec(700*S, MTol, Inter);

	% Tests:   EYawOf*
	% Assumes: Rand*, EulerFrom*
	P = P & TestEYawOf(3000*S, HTol, Inter);

	% Tests:   FYawOf*
	% Assumes: Rand*, FusedFrom*
	P = P & TestFYawOf(3000*S, HTol, Inter);

	% Tests:   ZVecFrom*
	% Assumes: Rand*, RotmatFrom*
	P = P & TestZVecFrom(3000*S, HTol, Inter);

	% Tests:   FromZVec*
	% Assumes: RandUnitVec, ZVecFrom*, FYawOf*
	P = P & TestFromZVec(3000*S, HTol, Inter);

	% Tests:   *FromFYawBzG
	% Assumes: RandUnitVec, FYawOf*, ZVecFrom*
	P = P & TestFromFYawBzG(3000*S, LTol, Inter);

	% Tests:   *FromFYawGzB
	% Assumes: RandUnitVec, FYawOf*, RotmatFrom*
	P = P & TestFromFYawGzB(3000*S, LTol, Inter);

	% Tests:   AngVelFrom*
	% Assumes: Rand*, RandUnitVec, QuatFrom*, QuatInv, ComposeQuat
	P = P & TestAngVelFrom(650*S, MTol, Inter);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  End of testing  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Calculate the total testing time
	if isOctave
		TimeTested = double(tic - StartTime) * 1e-6;
	else
		TimeTested = toc(StartTime);
	end
	Hours = floor(TimeTested/3600);
	TimeTested = TimeTested - Hours*3600;
	Mins = floor(TimeTested/60);
	Secs = TimeTested - Mins*60;

	% Display the total testing time
	fprintf('##############################\n');
	fprintf('Total time taken: %02d:%02d:%06.3f\n', Hours, Mins, Secs);
	fprintf('\n');

	% Convert the pass flag into a string
	if P
		PStr = 'PASS';
	else
		PStr = 'FAIL';
	end

	% Summarise the test results
	fprintf('######################################################################\n');
	fprintf('###########  End of Rotations Library testing => * %s *  ###########\n', PStr);
	fprintf('######################################################################\n');
	fprintf('\n');

	% Set the output pass flag
	if nargout >= 1
		Pass = P;
	end

end
% EOF