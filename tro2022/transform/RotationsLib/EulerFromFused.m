% EulerFromFused.m - Philipp Allgeuer - 05/11/14
% Converts a fused angles rotation to the corresponding ZYX Euler angles representation.
%
% function [Euler, Tilt] = EulerFromFused(Fused)
%
% The output ranges are:
% Yaw:   psi   is in (-pi,pi]
% Pitch: theta is in [-pi/2,pi/2]
% Roll:  phi   is in (-pi,pi]
%
% Fused  ==> Input fused angles rotation
% Euler  ==> Equivalent ZYX Euler angles rotation
% Tilt   ==> Equivalent tilt angles rotation

% Main function
function [Euler, Tilt] = EulerFromFused(Fused)

	% Precalculate the sin values
	sth  = sin(Fused(2));
	sphi = sin(Fused(3));

	% Calculate the cos of the tilt angle alpha
	crit = sth*sth + sphi*sphi;
	if crit >= 1.0
		calpha = 0.0;
	else
		if Fused(4) >= 0
			calpha =  sqrt(1-crit);
		else
			calpha = -sqrt(1-crit);
		end
	end

	% Calculate the tilt axis angle gamma
	gamma = atan2(sth,sphi);

	% Precalculate the required trigonometric terms
	cgam = cos(gamma); % Equals sphi/salpha
	sgam = sin(gamma); % Equals sth/salpha
	psigam = Fused(1) + gamma;
	cpsigam = cos(psigam);
	spsigam = sin(psigam);
	A = sgam*calpha;

	% Calculate the required Euler angles representation
	Euler = [atan2(cgam*spsigam-A*cpsigam,cgam*cpsigam+A*spsigam) Fused(2) atan2(sphi,calpha)]; % Note: Fused pitch is equivalent to ZYX Euler pitch!

	% Calculate the required tilt angles representation
	if nargout >= 2
		Tilt = [Fused(1) gamma acos(calpha)];
	end

end
% EOF