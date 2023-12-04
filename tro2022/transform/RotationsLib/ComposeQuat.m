% ComposeQuat.m - Philipp Allgeuer - 05/11/14
% Composes multiple quaternion rotations and returns the equivalent
% total rotation.
% 
% function [Qout] = ComposeQuat(varargin)
% 
% The rotations are applied right to left. That is, ComposeQuat(Q3,Q2,Q1)
% returns the rotation given by applying Q1 then Q2 then Q3.
%
% Qout ==> Quaternion representation of the composed rotation

% Main function
function [Qout] = ComposeQuat(varargin)

	% Compose the required rotations
	Num = length(varargin);
	if Num <= 0
		Qout = [1 0 0 0];
	else
		Qout = varargin{1};
		for k = 2:Num
			Q = varargin{k};
			if numel(Q) ~= 4
				warning('Ignoring an invalid rotation parameter!');
				continue;
			end
			Qout = [Qout(1)*Q(1)-dot(Qout(2:4),Q(2:4)) Qout(1)*Q(2:4)+Q(1)*Qout(2:4)+cross(Qout(2:4),Q(2:4))];
		end
	end

end
% EOF