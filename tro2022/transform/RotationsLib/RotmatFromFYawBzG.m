% RotmatFromFYawBzG - Philipp Allgeuer - 20/10/16
% Calculates the rotation matrix (RGB) with a given fused yaw and global z-axis in body-fixed coordinates (BzG).
%
% function [RGB, qGB] = RotmatFromFYawBzG(FYaw, BzG)
%
% It is assumed that BzG is a unit vector!
% BzG by definition will always be the third row of RGB.

% Main function
function [RGB, qGB] = RotmatFromFYawBzG(FYaw, BzG)

	% Calculate the quaternion representation of the required rotation
	qGB = QuatFromFYawBzG(FYaw, BzG);

	% Return the required rotation matrix representation
	RGB = RotmatFromQuat(qGB);

end
% EOF