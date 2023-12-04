% ZVecFromFused.m - Philipp Allgeuer - 20/10/16
% Converts a fused angles rotation to the corresponding z-vector.
%
% function [ZVec] = ZVecFromFused(Fused)
%
% Fused ==> Input fused angles rotation
% ZVec  ==> Corresponding z-vector

% Main function
function [ZVec] = ZVecFromFused(Fused)

	% Precalculate the sin values
	sth  = sin(Fused(2));
	sphi = sin(Fused(3));

	% Calculate the cos of the tilt angle
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

	% Calculate the required z-vector
	ZVec = [-sth sphi calpha];

end
% EOF