% RotmatFromQuat.m - Philipp Allgeuer - 05/11/14
% Converts a quaternion rotation to the corresponding rotation matrix representation.
%
% function [Rotmat] = RotmatFromQuat(Quat)
%
% The output of this function is a 3x3 matrix that to machine precision is orthogonal.
% Note however, that it cannot be assumed that every element of Rotmat is strictly and
% irrefutably in the range [-1,1]. It is possible that values such as 1+k*eps come out,
% and so care should be taken when applying (for instance) inverse trigonometric functions
% (e.g. asin, acos) to the rotation matrix elements, as otherwise complex values may result. 
%
% Quat   ==> Input quaternion rotation (assumed to have unit norm)
% Rotmat ==> Equivalent rotation matrix

% Main function
function [Rotmat] = RotmatFromQuat(Quat)

	% Data aliases
	w = Quat(1);
	x = Quat(2);
	y = Quat(3);
	z = Quat(4);

	% Construct the required rotation matrix (assuming the quaternion is normalised)
	Rotmat = [1-2*(y*y+z*z)  2*(x*y-z*w)   2*(x*z+y*w) ;
	           2*(x*y+z*w)  1-2*(x*x+z*z)  2*(y*z-x*w) ;
	           2*(x*z-y*w)   2*(y*z+x*w)  1-2*(x*x+y*y)];

end
% EOF