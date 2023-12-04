% PhaseFromTilt.m - Philipp Allgeuer - 16/01/18
% Converts a tilt angles rotation to the corresponding tilt phase representation.
%
% function [Phase] = PhaseFromTilt(Tilt)
%
% Tilt  ==> Input tilt angles rotation
% Phase ==> Equivalent tilt phase rotation

% Main function
function [Phase] = PhaseFromTilt(Tilt)

	% Construct the output tilt phase
	Phase = [Tilt(3)*cos(Tilt(2)) Tilt(3)*sin(Tilt(2)) Tilt(1)];

end
% EOF