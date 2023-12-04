% QuatFromAbsPhase.m - Philipp Allgeuer - 16/01/18
% Converts an absolute tilt phase rotation to the corresponding quaternion representation.
%
% function [Quat, Tilt] = QuatFromAbsPhase(AbsPhase)
%
% AbsPhase ==> Input absolute tilt phase rotation
% Quat     ==> Equivalent quaternion rotation

% Main function
function [Quat, Tilt] = QuatFromAbsPhase(AbsPhase)

	% Construct the output quaternion
	Tilt = TiltFromAbsPhase(AbsPhase);
	Quat = QuatFromTilt(Tilt);

end
% EOF