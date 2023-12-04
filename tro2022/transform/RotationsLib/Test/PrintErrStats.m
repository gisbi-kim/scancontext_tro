% PrintErrStats.m - Philipp Allgeuer - 05/11/14
% Prints statistics about an error array that was generated as part of a test item.
%
% function [Pass] = PrintErrStats(Err, Title, Tol)
%
% Test items are the constituents of an individual test. If all of the errors are
% below the specified tolerance in absolute terms the test item is declared passed.
%
% Err   ==> The error data to print the statistics of
% Title ==> The name to use for this test item
% Tol   ==> The numerical bound below which errors are acceptable
% Pass  ==> Boolean flag whether this test item was passed

% Main function
function [Pass] = PrintErrStats(Err, Title, Tol)

	% Default tolerance value
	if nargin < 3
		Tol = 128*eps;
	end

	% Initialise the pass flag
	Pass = false;

	% Print header for the results
	fprintf('TEST ITEM: %s\n', Title);

	% Ensure that error data is actually available
	if size(Err,1) < 2
		fprintf('WARNING: No error data was available (need >1 rows)!          * FAIL *\n');
		warning('A warning occurred while trying to print out the error statistics.');
		return;
	end

	% Calculate the error maxima and minima
	abserr = abs(Err);
	absmin = min(abserr);
	absmax = max(abserr);
	maxabsmax = max(absmax);

	% Evaluate the pass criterion
	Pass = (maxabsmax <= Tol);
	if Pass
		str = 'PASS';
	else
		str = 'FAIL';
	end

	% Print the error maxima and minima, and whether the test was passed
	fprintf('Err     minimum: %s\n', sprintf('%11.3e ',min(Err)));
	fprintf('Err     maximum: %s\n', sprintf('%11.3e ',max(Err)));
	fprintf('Err abs minimum: %s\n', sprintf('%11.3e ',absmin));
	fprintf('Err abs maximum: %s <--- ABS MAX:  %11.3e      * %s *\n', sprintf('%11.3e ',absmax),maxabsmax,str);

	% Partition the error values into logarithmically spaced bins
	bins = [0 10.^(-15:0) Inf];
	count = histc(abserr,bins,1);
	while all(count(end,:) == 0)
		count(end,:) = [];
	end
	bincumul = cumsum(count,1);

	% Issue warnings if we detect infinite and/or NaN values
	warnhappened = false;
	total = size(Err,1);
	if ~all(isfinite(Err))
		fprintf('WARNING: There are non-finite values in the array!\n');
		warnhappened = true;
	end
	if any(bincumul(end,:) ~= total)
		fprintf('WARNING: Sums don''t match => There be NaNs!\n');
		warnhappened = true;
	end
	if warnhappened
		warning('A warning occurred while trying to print out the error statistics.');
	end

	% Print out a list of the error bins and the corresponding exceedance frequencies
	fprintf('Less than %5.0e:   %s\n', bins(2), sprintf('%d  ',bincumul(1,:)));
	for k = 1:size(bincumul,1)
		if k+1 <= numel(bins)
			fprintf('More than %5.0e:   %s\n', bins(k+1), sprintf('%d  ',total-bincumul(k,:)));
		end
	end
	fprintf('\n');

	% Flush the printed output to screen
	if isOctave
		fflush(stdout);
	else
		drawnow('update');
	end

end
% EOF