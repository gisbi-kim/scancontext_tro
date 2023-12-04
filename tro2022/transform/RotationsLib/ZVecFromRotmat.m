% ZVecFromRotmat.m - Philipp Allgeuer - 20/10/16
% Converts a rotation matrix to the corresponding z-vector.
%
% function [ZVec] = ZVecFromRotmat(Rotmat)
%
% Rotmat ==> Input rotation matrix
% ZVec   ==> Corresponding z-vector

% Main function
function [ZVec] = ZVecFromRotmat(Rotmat)

	% Retrieve the required z-vector
	ZVec = Rotmat(3,:);

end
% EOF