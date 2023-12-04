% TiltFromPhase.m - Philipp Allgeuer - 16/01/18
% Converts a tilt phase rotation to the corresponding tilt angles representation.
%
% function [Tilt] = TiltFromPhase(Phase)
%
% Phase ==> Input tilt phase rotation
% Tilt  ==> Equivalent tilt angles rotation

% Main function
function [Tilt] = TiltFromPhase(Phase)

	% Construct the output tilt angles
	psi = Phase(3);
	gamma = atan2(Phase(2), Phase(1));
	alpha = sqrt(Phase(1)*Phase(1) + Phase(2)*Phase(2));
	Tilt = [psi gamma alpha];

end
% EOF