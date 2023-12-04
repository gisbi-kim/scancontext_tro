% AbsPhaseFromTilt.m - Philipp Allgeuer - 16/01/18
% Converts a tilt angles rotation to the corresponding absolute tilt phase representation.
%
% function [AbsPhase] = AbsPhaseFromTilt(Tilt)
%
% Tilt     ==> Input tilt angles rotation
% AbsPhase ==> Equivalent absolute tilt phase rotation

% Main function
function [AbsPhase] = AbsPhaseFromTilt(Tilt)

	% Construct the output absolute tilt phase
	psigam = Tilt(1) + Tilt(2);
	AbsPhase = [Tilt(3)*cos(psigam) Tilt(3)*sin(psigam) Tilt(1)];

end
% EOF