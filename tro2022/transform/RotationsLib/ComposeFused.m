% ComposeFused.m - Philipp Allgeuer - 05/11/14
% Composes multiple fused angles rotations and returns the equivalent
% total rotation.
% 
% function [Fout, Rout] = ComposeFused(varargin)
% 
% The rotations are applied right to left. That is, ComposeFused(F3,F2,F1)
% returns the rotation given by applying F1 then F2 then F3.
%
% Fout ==> Fused angles representation of the composed rotation
% Rout ==> Rotation matrix representation of the composed rotation

% Main function
function [Fout, Rout] = ComposeFused(varargin)

	% Compose the required rotations
	Num = length(varargin);
	if Num <= 0
		Fout = [0 0 0 1];
		Rout = eye(3);
	elseif Num == 1
		Fout = varargin{1};
		if nargout >= 2
			Rout = RotmatFromFused(Fout);
		end
	else
		Rout = RotmatFromFused(varargin{1});
		for k = 2:Num
			F = varargin{k};
			if numel(F) ~= 4
				warning('Ignoring an invalid rotation parameter!');
				continue;
			end
			Rout = Rout * RotmatFromFused(F);
		end
		Fout = FusedFromRotmat(Rout);
	end

end
% EOF