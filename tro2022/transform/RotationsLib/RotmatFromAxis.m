% RotmatFromAxis.m - Philipp Allgeuer - 05/11/14
% Constructs a rotation matrix based on an axis-angle specification.
%
% function [Rotmat] = RotmatFromAxis(Axis, Angle)
%
% Axis   ==> The vector corresponding to the axis of rotation (magnitude is unimportant)
%            either given as the vector [ux uy uz] or one of {'x', 'y', 'z'}
% Angle  ==> The angle of the rotation given by the right hand rule
% Rotmat ==> Equivalent rotation matrix

% Main function
function [Rotmat] = RotmatFromAxis(Axis, Angle)

	% Handle case of missing arguments
	if nargin < 2
		Rotmat = eye(3);
		return;
	end

	% Precompute the required sin and cos terms
	cang = cos(Angle);
	sang = sin(Angle);

	% Handle case of standard axis rotations
	if strcmpi(Axis, 'x')
		Rotmat = [1 0 0;0 cang -sang;0 sang cang];
		return;
	elseif strcmpi(Axis, 'y')
		Rotmat = [cang 0 sang;0 1 0;-sang 0 cang];
		return;
	elseif strcmpi(Axis, 'z')
		Rotmat = [cang -sang 0;sang cang 0;0 0 1];
		return;
	end

	% Axis error checking
	if ~(isnumeric(Axis) && isvector(Axis) && length(Axis) == 3)
		error('Axis must be a 3-vector, or one of {''x'',''y'',''z''}.');
	end

	% Normalise the axis vector
	AxisNorm = norm(Axis);
	if AxisNorm <= 0
		Rotmat = eye(3); % Return the identity rotation if Axis is the zero vector
		return;
	else
		Axis = Axis/AxisNorm;
	end

	% Precompute the required terms
	C = 1 - cang;
	xC = Axis(1)*C;
	yC = Axis(2)*C;
	zC = Axis(3)*C;
	xxC = Axis(1)*xC;
	yyC = Axis(2)*yC;
	zzC = Axis(3)*zC;
	xyC = Axis(1)*yC;
	yzC = Axis(2)*zC;
	zxC = Axis(3)*xC;
	xs = Axis(1)*sang;
	ys = Axis(2)*sang;
	zs = Axis(3)*sang;

	% Construct the required rotation
	Rotmat = [xxC+cang xyC-zs zxC+ys;xyC+zs yyC+cang yzC-xs;zxC-ys yzC+xs zzC+cang];

end
% EOF