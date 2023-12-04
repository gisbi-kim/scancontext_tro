% AbsPhaseFromQuat.m - Philipp Allgeuer - 16/01/18
% Converts a quaternion rotation to the corresponding absolute tilt phase representation.
%
% function [AbsPhase, Tilt] = AbsPhaseFromQuat(Quat)
%
% Quat     ==> Input quaternion rotation
% AbsPhase ==> Equivalent absolute tilt phase rotation

% Main function
function [AbsPhase, Tilt] = AbsPhaseFromQuat(Quat)

	% Construct the output tilt phase
	Tilt = TiltFromQuat(Quat);
	AbsPhase = AbsPhaseFromTilt(Tilt);

end
% EOF