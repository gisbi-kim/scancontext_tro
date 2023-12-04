% AbsPhaseFromPhase.m - Philipp Allgeuer - 16/01/18
% Converts a tilt phase rotation to the corresponding absolute tilt phase representation.
%
% function [AbsPhase] = AbsPhaseFromPhase(Phase)
%
% Phase    ==> Input tilt phase rotation
% AbsPhase ==> Equivalent absolute tilt phase rotation

% Main function
function [AbsPhase] = AbsPhaseFromPhase(Phase)

	% Precalculate trigonometric values
	cpsi = cos(Phase(3));
	spsi = sin(Phase(3));
	
	% Construct the output absolute tilt phase
	AbsPhase = [cpsi*Phase(1)-spsi*Phase(2) spsi*Phase(1)+cpsi*Phase(2) Phase(3)];

end
% EOF