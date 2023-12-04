% ComposeTilt.m - Philipp Allgeuer - 05/11/14
% Composes multiple tilt angles rotations and returns the equivalent
% total rotation.
% 
% function [Tout, Rout] = ComposeTilt(varargin)
% 
% The rotations are applied right to left. That is, ComposeTilt(T3,T2,T1)
% returns the rotation given by applying T1 then T2 then T3.
%
% Tout ==> Tilt angles representation of the composed rotation
% Rout ==> Rotation matrix representation of the composed rotation

% Main function
function [Tout, Rout] = ComposeTilt(varargin)

	% Compose the required rotations
	Num = length(varargin);
	if Num <= 0
		Tout = [0 0 0];
		Rout = eye(3);
	elseif Num == 1
		Tout = varargin{1};
		if nargout >= 2
			Rout = RotmatFromTilt(Tout);
		end
	else
		Rout = RotmatFromTilt(varargin{1});
		for k = 2:Num
			T = varargin{k};
			if numel(T) ~= 3
				warning('Ignoring an invalid rotation parameter!');
				continue;
			end
			Rout = Rout * RotmatFromTilt(T);
		end
		Tout = TiltFromRotmat(Rout);
	end

end
% EOF