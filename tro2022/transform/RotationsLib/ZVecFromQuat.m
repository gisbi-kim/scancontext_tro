% ZVecFromQuat.m - Philipp Allgeuer - 20/10/16
% Converts a quaternion rotation to the corresponding z-vector.
%
% function [ZVec] = ZVecFromQuat(Quat)
%
% Note that the output of this function to machine precision is orthogonal, as long as
% the input quaternion is. It is possible however that one of the values comes out as
% +-(1+k*eps), so be careful with inverse trigonometric functions.
%
% Quat ==> Input quaternion rotation (assumed to have unit norm)
% ZVec ==> Corresponding z-vector

% Main function
function [ZVec] = ZVecFromQuat(Quat)

	% Data aliases
	w = Quat(1);
	x = Quat(2);
	y = Quat(3);
	z = Quat(4);

	% Construct the required z-vector (assuming the quaternion is normalised)
	ZVec = [2*(x*z-y*w) 2*(y*z+x*w) 1-2*(x*x+y*y)];

end
% EOF