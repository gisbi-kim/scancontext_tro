% EulerFromRotmat.m - Philipp Allgeuer - 05/11/14
% Converts a rotation matrix to the corresponding ZYX Euler angles representation.
%
% function [Euler] = EulerFromRotmat(Rotmat)
%
% The output ranges are:
% Yaw:   psi   is in (-pi,pi]
% Pitch: theta is in [-pi/2,pi/2]
% Roll:  phi   is in (-pi,pi]
%
% Rotmat ==> Input rotation matrix
% Euler  ==> Equivalent ZYX Euler angles rotation

% Main function
function [Euler] = EulerFromRotmat(Rotmat)

	% Extract the sin of the theta angle
	sth = max(min(-Rotmat(3,1),1.0),-1.0); % Note: If Rotmat is valid then this should only trim at most a few eps...

	% Calculate the required Euler angles
	Euler = [atan2(Rotmat(2,1),Rotmat(1,1)) asin(sth) atan2(Rotmat(3,2),Rotmat(3,3))];

end
% EOF