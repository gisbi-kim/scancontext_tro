% QuatFromFused.m - Philipp Allgeuer - 05/11/14
% Converts a fused angles rotation to the corresponding quaternion representation.
%
% function [Quat, Tilt] = QuatFromFused(Fused)
%
% The output quaternion is in the format [w x y z].
%
% Fused ==> Input fused angles rotation
% Quat  ==> Equivalent quaternion rotation

% Main function
function [Quat, Tilt] = QuatFromFused(Fused)

	% Precalculate the required trigonometric values
	hpsi  = Fused(1)/2;
	chpsi = cos(hpsi);
	shpsi = sin(hpsi);
	sth   = sin(Fused(2));
	sphi  = sin(Fused(3));

	% Calculate the cos of the tilt angle
	crit = sth*sth + sphi*sphi;
	if crit >= 1.0
		calpha = 0;
	else
		if Fused(4) >= 0
			calpha =  sqrt(1-crit);
		else
			calpha = -sqrt(1-crit);
		end
	end

	% Construct the output quaternion using the best conditioned expression
	if calpha >= 0

		% Precalculate terms involved in the quaternion expression
		C = 1 + calpha;

		% Calculate the required quaternion
		Quat = [C*chpsi sphi*chpsi-sth*shpsi sphi*shpsi+sth*chpsi C*shpsi];
		Quat = Quat/sqrt(C*C+crit); % Note: norm(Quat) = sqrt(C*C+sth*sth+sphi*sphi) = sqrt(2*C) > 1

		% Return the tilt angles representation
		if nargout >= 2
			gamma = atan2(sth,sphi);
			alpha = acos(calpha);
			Tilt = [Fused(1) gamma alpha];
		end

	else

		% Calculate the sin of the tilt angle
		if crit >= 1.0
			salpha = 1.0;
		else
			salpha = sqrt(crit);
		end

		% Precalculate terms involved in the quaternion expression
		C = 1 - calpha;
		gamma = atan2(sth,sphi);
		hgampsi = gamma + hpsi;
		chgampsi = cos(hgampsi);
		shgampsi = sin(hgampsi);

		% Calculate the required quaternion
		Quat = [salpha*chpsi C*chgampsi C*shgampsi salpha*shpsi];
		Quat = Quat/sqrt(C*C+crit); % Note: norm(Quat) = sqrt(C*C+sth*sth+sphi*sphi) = sqrt(2*C) > 1

		% Return the tilt angles representation
		if nargout >= 2
			alpha = acos(calpha);
			Tilt = [Fused(1) gamma alpha];
		end

	end

end
% EOF