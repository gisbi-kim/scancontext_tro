% AngVelFromEulerVel.m - Philipp Allgeuer - 05/11/14
% Convert a ZYX Euler angles velocity to an angular velocity vector
%
% function [AngVel] = AngVelFromEulerVel(Euler, EulerVel)
%
% The angular velocity vector is expressed in global coordinates.
%
% Euler    ==> ZYX Euler angles rotation [phi theta psi]
% EulerVel ==> ZYX Euler angles velocity [dphi dtheta dpsi]
% AngVel   ==> Angular velocity vector [wx;wy;wz]

% Main function
function [AngVel] = AngVelFromEulerVel(Euler, EulerVel)

	% Precompute sin and cos values
	cphi = cos(Euler(1));
	sphi = sin(Euler(1));
	cth  = cos(Euler(2));
	sth  = sin(Euler(2));

	% Store Euler angle velocities in conveniently named variables
	dphi = EulerVel(1);
	dth  = EulerVel(2);
	dpsi = EulerVel(3);

	% Calculate the angular velocity vector in unrotated global coordinates
	AngVel = [dpsi*cth*cphi-dth*sphi ; dpsi*cth*sphi+dth*cphi ; dphi-dpsi*sth];

end
% EOF