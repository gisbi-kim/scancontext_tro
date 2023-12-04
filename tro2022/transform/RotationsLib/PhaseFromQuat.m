% PhaseFromQuat.m - Philipp Allgeuer - 16/01/18
% Converts a quaternion rotation to the corresponding tilt phase representation.
%
% function [Phase, Tilt] = PhaseFromQuat(Quat)
%
% Quat  ==> Input quaternion rotation
% Phase ==> Equivalent tilt phase rotation

% Main function
function [Phase, Tilt] = PhaseFromQuat(Quat)

	% Construct the output tilt phase
	Tilt = TiltFromQuat(Quat);
	Phase = PhaseFromTilt(Tilt);

end
% EOF