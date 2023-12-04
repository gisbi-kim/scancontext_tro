% PhaseFromAbsPhase.m - Philipp Allgeuer - 16/01/18
% Converts an absolute tilt phase rotation to the corresponding tilt phase representation.
%
% function [Phase] = PhaseFromAbsPhase(AbsPhase)
%
% AbsPhase ==> Input absolute tilt phase rotation
% Phase    ==> Equivalent tilt phase rotation

% Main function
function [Phase] = PhaseFromAbsPhase(AbsPhase)

	% Precalculate trigonometric values
	cpsi = cos(AbsPhase(3));
	spsi = sin(AbsPhase(3));
	
	% Construct the output tilt phase
	Phase = [cpsi*AbsPhase(1)+spsi*AbsPhase(2) cpsi*AbsPhase(2)-spsi*AbsPhase(1) AbsPhase(3)];

end
% EOF