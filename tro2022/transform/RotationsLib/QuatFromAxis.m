% QuatFromAxis.m - Philipp Allgeuer - 05/11/14
% Constructs a quaternion rotation based on an axis-angle specification.
%
% function [Quat] = QuatFromAxis(Axis, Angle)
%
% Axis  ==> The vector corresponding to the axis of rotation (magnitude is unimportant)
%           either given as the vector [ux uy uz] or one of {'x', 'y', 'z'}
% Angle ==> The angle of the rotation given by the right hand rule
% Quat  ==> Equivalent quaternion rotation

% Main function
function [Quat] = QuatFromAxis(Axis, Angle)

	% Handle case of missing arguments
	if nargin < 2
		Quat = [1 0 0 0];
		return;
	end

	% Wrap the rotation angle to (-pi,pi]
	Angle = wrap(Angle);

	% Precompute the required sin and cos terms
	hcang = cos(Angle/2);
	hsang = sin(Angle/2);

	% Handle case of standard axis rotations
	if strcmpi(Axis, 'x')
		Quat = [hcang hsang 0 0];
		return;
	elseif strcmpi(Axis, 'y')
		Quat = [hcang 0 hsang 0];
		return;
	elseif strcmpi(Axis, 'z')
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
		Quat = [1 0 0 0]; % Return the identity rotation if Axis is the zero vector
		return;
	else
		Axis = Axis/AxisNorm;
	end

	% Construct the required rotation
	Quat = [hcang hsang*Axis(:)'];

end
% EOF