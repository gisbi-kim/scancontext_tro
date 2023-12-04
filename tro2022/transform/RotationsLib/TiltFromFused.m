% TiltFromFused.m - Philipp Allgeuer - 05/11/14
% Converts a fused angles rotation to the corresponding tilt angles representation.
%
% function [Tilt] = TiltFromFused(Fused)
%
% The output ranges are:
% Fused yaw:        psi   is in (-pi,pi]
% Tilt axis angle:  gamma is in (-pi,pi]
% Tilt angle:       alpha is in [0,pi]
%
% Fused ==> Input fused angles rotation
% Tilt  ==> Equivalent tilt angles rotation

% Main function
function [Tilt] = TiltFromFused(Fused)

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

	% Calculate the tilt axis angle and the tilt angle
	gamma = atan2(sth,sphi);
	alpha = acos(calpha);

	% Return the tilt angles representation
	Tilt = [Fused(1) gamma alpha];

end
% EOF