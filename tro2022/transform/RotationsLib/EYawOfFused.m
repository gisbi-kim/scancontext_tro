% EYawOfFused.m - Philipp Allgeuer - 05/11/14
% Calculates the ZYX yaw of a fused angles rotation.
%
% function [EYaw] = EYawOfFused(Fused)
%
% Fused ==> Input fused angles rotation
% EYaw  ==> ZYX yaw of the input rotation

% Main function
function [EYaw] = EYawOfFused(Fused)

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

	% Precalculate trigonometric terms involved in the rotation matrix expression
	psigam = Fused(1) + gamma;
	cpsigam = cos(psigam);
	spsigam = sin(psigam);
	cgam = cos(gamma);
	sgam = sin(gamma);
	A = sgam*calpha;

	% Calculate the ZYX yaw
	EYaw = atan2(cgam*spsigam-A*cpsigam, cgam*cpsigam+A*spsigam);

end
% EOF