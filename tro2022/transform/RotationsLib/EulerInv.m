% EulerInv.m - Philipp Allgeuer - 05/11/14
% Calculates the inverse of a ZYX Euler angles rotation.
%
% function [Einv] = EulerInv(E)
%
% E    ==> Input ZYX Euler angles rotation
% Einv ==> Inverse ZYX Euler angles rotation

% Main function
function [Einv] = EulerInv(E)

	% Precalculate the required sin and cos values
	cpsi = cos(E(1));
	cth  = cos(E(2));
	cphi = cos(E(3));
	spsi = sin(E(1));
	sth  = sin(E(2));
	sphi = sin(E(3));

	% Extract the sin of the theta angle
	newsth = max(min(-(cpsi*sth*cphi+spsi*sphi),1.0),-1.0); % Note: This should only trim at most a few eps...

	% Calculate the required inverse Euler angles representation
	Einv = [atan2(cpsi*sth*sphi-spsi*cphi,cpsi*cth) asin(newsth) atan2(spsi*sth*cphi-cpsi*sphi,cth*cphi)];

end
% EOF