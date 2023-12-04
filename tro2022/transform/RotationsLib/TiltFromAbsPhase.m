% TiltFromAbsPhase.m - Philipp Allgeuer - 16/01/18
% Converts an absolute tilt phase rotation to the corresponding tilt angles representation.
%
% function [Tilt] = TiltFromAbsPhase(AbsPhase)
%
% AbsPhase ==> Input absolute tilt phase rotation
% Tilt     ==> Equivalent tilt angles rotation

% Main function
function [Tilt] = TiltFromAbsPhase(AbsPhase)

	% Construct the output tilt angles
	psi = AbsPhase(3);
	gamma = atan2(AbsPhase(2), AbsPhase(1)) - psi;
	gamma = wrap(gamma);
	alpha = sqrt(AbsPhase(1)*AbsPhase(1) + AbsPhase(2)*AbsPhase(2));
	Tilt = [psi gamma alpha];

end
% EOF