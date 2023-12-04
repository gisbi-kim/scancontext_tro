% ComposeEuler.m - Philipp Allgeuer - 05/11/14
% Composes multiple ZYX Euler angles rotations and returns the equivalent
% total rotation.
% 
% function [Eout, Rout] = ComposeEuler(varargin)
% 
% The rotations are applied right to left. That is, ComposeEuler(E3,E2,E1)
% returns the rotation given by applying E1 then E2 then E3.
%
% Eout ==> ZYX Euler angles representation of the composed rotation
% Rout ==> Rotation matrix representation of the composed rotation

% Main function
function [Eout, Rout] = ComposeEuler(varargin)

	% Compose the required rotations
	Num = length(varargin);
	if Num <= 0
		Eout = [0 0 0];
		Rout = eye(3);
	elseif Num == 1
		Eout = varargin{1};
		if nargout >= 2
			Rout = RotmatFromEuler(Eout);
		end
	else
		Rout = RotmatFromEuler(varargin{1});
		for k = 2:Num
			E = varargin{k};
			if numel(E) ~= 3
				warning('Ignoring an invalid rotation parameter!');
				continue;
			end
			Rout = Rout * RotmatFromEuler(E);
		end
		Eout = EulerFromRotmat(Rout);
	end

end
% EOF