% RotmatFromFYawGzB - Philipp Allgeuer - 26/10/16
% Calculates the rotation matrix (RGB) with a given fused yaw and body-fixed z-axis in global coordinates (GzB).
%
% function [RGB, qGB] = RotmatFromFYawGzB(FYaw, GzB)
%
% It is assumed that GzB is a unit vector!
% GzB by definition will always be the third column of RGB.

% Main function
function [RGB, qGB] = RotmatFromFYawGzB(FYaw, GzB)

	% Calculate the quaternion representation of the required rotation
	qGB = QuatFromFYawGzB(FYaw, GzB);

	% Return the required rotation matrix representation
	RGB = RotmatFromQuat(qGB);

end
% EOF