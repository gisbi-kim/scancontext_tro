% QuatFromPhase.m - Philipp Allgeuer - 16/01/18
% Converts a tilt phase rotation to the corresponding quaternion representation.
%
% function [Quat, Tilt] = QuatFromPhase(Phase)
%
% Phase ==> Input tilt phase rotation
% Quat  ==> Equivalent quaternion rotation

% Main function
function [Quat, Tilt] = QuatFromPhase(Phase)

	% Construct the output quaternion
	Tilt = TiltFromPhase(Phase);
	Quat = QuatFromTilt(Tilt);

end
% EOF