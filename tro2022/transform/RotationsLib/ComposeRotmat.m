% ComposeRotmat.m - Philipp Allgeuer - 05/11/14
% Composes multiple rotation matrices and returns the equivalent
% total rotation.
% 
% function [Rout] = ComposeRotmat(varargin)
% 
% The rotations are applied right to left. That is, ComposeRotmat(R3,R2,R1)
% returns the rotation given by applying R1 then R2 then R3.
%
% Rout ==> Rotation matrix representation of the composed rotation

% Main function
function [Rout] = ComposeRotmat(varargin)

	% Compose the required rotations
	Num = length(varargin);
	if Num <= 0
		Rout = eye(3);
	else
		Rout = varargin{1};
		for k = 2:Num
			R = varargin{k};
			if size(R,1) ~= 3 || size(R,2) ~= 3
				warning('Ignoring an invalid rotation parameter!');
				continue;
			end
			Rout = Rout * R;
		end
	end

end
% EOF