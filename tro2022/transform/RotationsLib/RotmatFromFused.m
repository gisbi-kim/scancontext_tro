% RotmatFromFused.m - Philipp Allgeuer - 05/11/14
% Converts a fused angles rotation to the corresponding rotation matrix representation.
%
% function [Rotmat, Tilt] = RotmatFromFused(Fused)
%
% The output of this function is a 3x3 matrix that to machine precision is orthogonal.
% Note however, that it cannot be assumed that every element of Rotmat is strictly and
% irrefutably in the range [-1,1]. It is possible that values such as 1+k*eps come out,
% and so care should be taken when applying (for instance) inverse trigonometric functions
% (e.g. asin, acos) to the rotation matrix elements, as otherwise complex values may result. 
%
% Fused  ==> Input fused angles rotation
% Rotmat ==> Equivalent rotation matrix
% Tilt   ==> Equivalent tilt angles rotation

% Main function
function [Rotmat, Tilt] = RotmatFromFused(Fused)

	% Precalculate the sin values
	sth  = sin(Fused(2));
	sphi = sin(Fused(3));

	% Calculate the sin and cos of the tilt angle
	crit = sth*sth + sphi*sphi;
	if crit >= 1.0
		salpha = 1.0;
		calpha = 0.0;
	else
		salpha = sqrt(crit);
		if Fused(4) >= 0
			calpha =  sqrt(1-crit);
		else
			calpha = -sqrt(1-crit);
		end
	end

	% Calculate the tilt axis angle gamma
	gamma = atan2(sth,sphi);

	% Precalculate trigonometric terms involved in the rotation matrix expression
	cgam = cos(gamma); % Equals sphi/salpha
	sgam = sin(gamma); % Equals sth/salpha
	psigam = Fused(1) + gamma;
	cpsigam = cos(psigam);
	spsigam = sin(psigam);

	% Precalculate additional terms involved in the rotation matrix expression
	A = cgam * cpsigam;
	B = sgam * cpsigam;
	C = cgam * spsigam;
	D = sgam * spsigam;

	% Calculate the required rotation matrix
	Rotmat = [A+D*calpha B-C*calpha  salpha*spsigam;
	          C-B*calpha D+A*calpha -salpha*cpsigam;
	          -sth       sphi        calpha];

	% Calculate the required tilt angles representation
	if nargout >= 2
		Tilt = [Fused(1) gamma acos(calpha)];
	end

end
% EOF