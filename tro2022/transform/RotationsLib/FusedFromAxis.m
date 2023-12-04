% FusedFromAxis.m - Philipp Allgeuer - 05/11/14
% Constructs a fused angles rotation based on an axis-angle specification.
%
% function [Fused, Quat] = FusedFromAxis(Axis, Angle)
%
% Axis  ==> The vector corresponding to the axis of rotation (magnitude is unimportant)
%           either given as the vector [ux uy uz] or one of {'x', 'y', 'z'}
% Angle ==> The angle of the rotation given by the right hand rule
% Fused ==> Equivalent fused angles rotation
% Quat  ==> Equivalent quaternion rotation

% Main function
function [Fused, Quat] = FusedFromAxis(Axis, Angle)

	% Handle case of missing arguments
	if nargin < 2
		Fused = [0 0 0 1];
		Quat = [1 0 0 0];
		return;
	end
	
	% Get the required value of pi
	PI = GetPI(Angle);

	% Wrap the rotation angle to (-pi,pi]
	Angle = wrap(Angle);

	% Precompute the required sin and cos terms
	hcang = cos(Angle/2);
	hsang = sin(Angle/2);

	% Handle case of standard axis rotations
	if strcmpi(Axis, 'x')
		if abs(Angle) <= PI/2
			Fused = [0 0 Angle 1];
		elseif Angle >= PI/2
			Fused = [0 0 PI-Angle -1];
		else
			Fused = [0 0 -PI-Angle -1];
		end
		Quat = [hcang hsang 0 0];
		return;
	elseif strcmpi(Axis, 'y')
		if abs(Angle) <= PI/2
			Fused = [0 Angle 0 1];
		elseif Angle >= PI/2
			Fused = [0 PI-Angle 0 -1];
		else
			Fused = [0 -PI-Angle 0 -1];
		end
		Quat = [hcang 0 hsang 0];
		return;
	elseif strcmpi(Axis, 'z')
		Fused = [Angle 0 0 1];
		Quat = [hcang 0 0 hsang];
		return;
	end

	% Axis error checking
	if ~(isnumeric(Axis) && isvector(Axis) && length(Axis) == 3)
		error('Axis must be a 3-vector, or one of {''x'',''y'',''z''}.');
	end

	% Normalise the axis vector
	AxisNorm = norm(Axis);
	if AxisNorm <= 0
		Fused = [0 0 0 1]; % Return the identity rotation if Axis is the zero vector
		Quat = [1 0 0 0];
		return;
	else
		Axis = Axis/AxisNorm;
	end

	% Construct the required rotation
	Quat = [hcang hsang*Axis(:)'];
	Fused = FusedFromQuat(Quat);

end
% EOF