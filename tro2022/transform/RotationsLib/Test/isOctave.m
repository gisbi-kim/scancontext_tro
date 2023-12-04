% isOctave.m - Philipp Allgeuer - 05/11/14
% Check whether the execution environment is Octave or Matlab.
%
% function [IsOct] = isOctave()
%
% IsOct ==> Boolean flag whether this script is running in Octave (true) or Matlab (false)

% Main function
function [IsOct] = isOctave()

	% Declare persistent boolean flag
	persistent O;

	% Define the flag if required
	if isempty(O)
		O = (exist('OCTAVE_VERSION', 'builtin') ~= 0);
	end

	% Copy the flag to the output
	IsOct = O;

end
% EOF