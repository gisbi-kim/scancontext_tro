% EndBoolean.m - Philipp Allgeuer - 05/11/14
% Convenience function for testing boolean conditions.
%
% function [B] = EndBoolean(B)
%
% The value of the B input (passed unmodified out of the function) should
% be a boolean specifying whether all boolean conditions were true in a test.
%
% B (in)  ==> Boolean flag whether all boolean tests were passed
% B (out) ==> Boolean flag whether all boolean tests were passed

% Main function
function [B] = EndBoolean(B)

	% Print a message whether the boolean conditions were satisfied
	if B
		fprintf('All boolean conditions passed!                                * PASS *\n');
	else
		fprintf('Failed due to boolean conditions!                             * FAIL *\n');
		warning('Boolean test(s) failed!');
	end
	fprintf('\n');

end
% EOF