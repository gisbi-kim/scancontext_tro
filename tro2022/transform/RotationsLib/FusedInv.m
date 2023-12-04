% FusedInv.m - Philipp Allgeuer - 05/11/14
% Calculates the inverse of a fused angles rotation.
%
% function [Finv] = FusedInv(F)
%
% F    ==> Input fused angles rotation
% Finv ==> Inverse fused angles rotation

% Main function
function [Finv] = FusedInv(F)

	% Calculate the tilt axis angle
	sth = sin(F(2));
	sph = sin(F(3));
	gamma = atan2(sth,sph);

	% Calculate the sin of the tilt angle
	crit = sth*sth + sph*sph;
	if crit >= 1.0
		salpha = 1.0;
	else
		salpha = sqrt(crit);
	end

	% Precalculate trigonometric values
	psigam = F(1) + gamma;
	cpsigam = cos(psigam);
	spsigam = sin(psigam);

	% Calculate the inverse fused pitch and roll
	thinv = asin(-salpha*spsigam);
	phinv = asin(-salpha*cpsigam);

	% Construct the inverse rotation
	Finv = [-F(1) thinv phinv F(4)];

end
% EOF