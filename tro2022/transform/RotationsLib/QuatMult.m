% QuatMult.m - Philipp Allgeuer - 03/11/16
% Multiplies together a series of quaternions.
% 
% function [Qout] = QuatMult(varargin)
% 
% For example: QuatMult(Q1,Q2,Q3) = Q1*Q2*Q3
%
% Qout ==> Quaternion representation of the composed rotation

% Main function
function [Qout] = QuatMult(varargin)

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