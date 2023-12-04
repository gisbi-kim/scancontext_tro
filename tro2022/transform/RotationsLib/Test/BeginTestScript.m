% BeginTestScript.m - Philipp Allgeuer - 05/11/14
% Function to be called at the beginning of a test script.
%
% function [Pass, Nnormal, Nlarge, Nsmall, Ntiny] = BeginTestScript(Title, N, Tol)
%
% Each test script may contain a multitude of individual tests. If each individual
% test returns PASS/true, then the entire test script returns PASS/true.
%
% Title   ==> The name to use for this test script
% N       ==> The nominal number of test cases to use in each individual test
% Tol     ==> The nominal numerical bound below which errors are acceptable
% Pass    ==> A pass flag to use that has been already initialised to true (use as Pass = Pass & EndTest(...))
% Nnormal ==> The number of test cases to use for normal tests
% Nlarge  ==> The number of test cases to use for fast tests
% Nsmall  ==> The number of test cases to use for slow tests
% Ntiny   ==> The number of test cases to use for ultraslow tests

% Main function
function [Pass, Nnormal, Nlarge, Nsmall, Ntiny] = BeginTestScript(Title, N, Tol)

	% Print header
	fprintf('======================================================================\n');
	fprintf('TEST SCRIPT: %s\n', Title);
	fprintf('N = %d\n',N);
	fprintf('Tol = %.3e\n',Tol);
	fprintf('\n');

	% Work out the various options for N
	Nlarge = max(round(10*N),5);
	Nnormal = max(round(N),5);
	Nsmall = max(round(N/10),5);
	Ntiny = max(round(N/300),5);

	% Initialise the pass flag
	Pass = true;

	% Flush the printed output to screen
	if isOctave
		fflush(stdout);
	else
		drawnow('update');
	end

end
% EOF