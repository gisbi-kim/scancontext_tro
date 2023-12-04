% EndTestScript.m - Philipp Allgeuer - 05/11/14
% Function to be called at the end of a test script.
%
% function EndTestScript(Title, Pass)
%
% Each test script may contain a multitude of individual tests. If each individual
% test returns PASS/true, then the entire test script returns PASS/true.
%
% Title ==> The name to use for this test script
% Pass  ==> Boolean flag specifying whether all the individual tests were passed

% Main function
function EndTestScript(Title, Pass)

	% Print a summary of the test script results
	fprintf('----------------------------------------------------------------------\n');
	fprintf('TEST SCRIPT: %s\n', Title);
	if Pass
		fprintf('Total result: * PASS *                                        * PASS *\n');
	else
		fprintf('Total result: * FAIL *                                        * FAIL *\n');
		warning('Test script failed!');
	end
	fprintf('Completed!\n');
	fprintf('\n');

	% Flush the printed output to screen
	if isOctave
		fflush(stdout);
	else
		drawnow('update');
	end

end
% EOF