% EnsureQuat.m - Philipp Allgeuer - 05/11/14
% Checks whether a quaternion rotation is valid to within a certain
% tolerance and fixes it if not.
%
% function [Qout, WasBad, Norm] = EnsureQuat(Qin, Tol, Unique)
%
% The input quaternion is assumed to be of the format [w x y z].
% the w parameter is positive. The zero quaternion gets fixed to the identity.
%
% Qin    ==> Input quaternion rotation
% Tol    ==> Tolerance bound for the L_inf norm of the input/output difference
% Unique ==> Boolean flag whether to make the output rotation unique
% Qout   ==> Output quaternion rotation (fixed)
% WasBad ==> Boolean flag whether the input and output differ more than Tol
% Norm   ==> The L_2 norm of the input quaternion

% Main function
function [Qout, WasBad, Norm] = EnsureQuat(Qin, Tol, Unique)

	% Default arguments
	if nargin < 2
		Tol = 1e-10;
	else
		Tol = abs(Tol);
	end
	if nargin < 3
		Unique = false;
	end

	% Make a copy of the input
	Qout = Qin;

	% Renormalise the quaternion
	Norm = norm(Qout);
	if Norm <= 0
		Qout = [1 0 0 0];   % Zero quaternion gets fixed to the identity quaternion
	else
		Qout = Qout / Norm; % Scale to unit norm
	end

	% Make the quaternion unique
	if Unique
		if Qout(1) < 0
			Qout = -Qout;
		end
	end

	% Work out whether we changed anything
	WasBad = any(abs(Qout - Qin) > Tol);

end
% EOF