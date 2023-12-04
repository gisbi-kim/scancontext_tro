% FusedFromRotmat.m - Philipp Allgeuer - 05/11/14
% Converts a rotation matrix to the corresponding fused angles representation.
%
% function [Fused, Tilt] = FusedFromRotmat(Rotmat)
%
% The output ranges are:
% Fused yaw:   psi   is in (-pi,pi]
% Fused pitch: theta is in [-pi/2,pi/2]
% Fused roll:  phi   is in [-pi/2,pi/2]
% Hemisphere:  h     is in {-1,1}
% 
% Rotmat ==> Input rotation matrix
% Fused  ==> Equivalent fused angles rotation
% Tilt   ==> Equivalent tilt angles rotation

% Main function
function [Fused, Tilt] = FusedFromRotmat(Rotmat)

	% Calculate the fused yaw
	psi = FYawOfRotmat(Rotmat);

	% Calculate the fused pitch
	stheta = max(min(-Rotmat(3,1),1.0),-1.0); % Note: If Rotmat is valid then this should only trim at most a few eps...
	theta = asin(stheta);

	% Calculate the fused roll
	sphi = max(min(Rotmat(3,2),1.0),-1.0); % Note: If Rotmat is valid then this should only trim at most a few eps...
	phi = asin(sphi);

	% See which hemisphere we're in
	if Rotmat(3,3) >= 0
		h = 1;
	else
		h = -1;
	end

	% Construct the output fused angles
	Fused = [psi theta phi h];

	% Construct the output tilt angles
	if nargout >= 2
		gamma = atan2(-Rotmat(3,1),Rotmat(3,2));
		calpha = max(min(Rotmat(3,3),1.0),-1.0); % Note: If Rotmat is valid then this should only trim at most a few eps...
		alpha = acos(calpha);
		Tilt = [psi gamma alpha];
	end

end
% EOF