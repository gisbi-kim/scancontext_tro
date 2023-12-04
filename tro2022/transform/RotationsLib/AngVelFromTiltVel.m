% AngVelFromTiltVel.m - Philipp Allgeuer - 02/05/17
% Convert a tilt angles velocity to an angular velocity vector
%
% function [AngVel] = AngVelFromTiltVel(Tilt, TiltVel)
%
% The angular velocity vector is expressed in global coordinates.
%
% Tilt    ==> Tilt angles rotation
% TiltVel ==> Tilt angles velocity
% AngVel  ==> Angular velocity column vector

% Main function
function [AngVel] = AngVelFromTiltVel(Tilt, TiltVel)

	% Precompute sin and cos values
	beta = Tilt(1) + Tilt(2);
	cbeta = cos(beta);
	sbeta = sin(beta);
	calpha = cos(Tilt(3));
	salpha = sin(Tilt(3));

	% Store tilt angles velocities in conveniently named variables
	dpsi = TiltVel(1);
	dgamma = TiltVel(2);
	dalpha = TiltVel(3);

	% Calculate the angular velocity vector in unrotated global coordinates
	AngVel = [cbeta*dalpha - salpha*sbeta*dgamma; sbeta*dalpha + salpha*cbeta*dgamma; dpsi + (1 - calpha)*dgamma];

end
% EOF