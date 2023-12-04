% TiltVectorSum.m - Philipp Allgeuer - 20/02/17
% Adds multiple tilt rotations together using a vectorial method.
%
% function [tilt] = TiltVectorSum(varargin)
%
% varargin ==> Input tilt rotations in the format [gamma alpha]
% tilt     ==> Output tilt rotation in the format [gamma alpha]
%
% The order of inputs is unimportant as vectorial addition is commutative and associative.
% Do not confuse 'tilt rotations' with 'tilt angles rotations'. To join the latter into a
% single rotation, refer to the ComposeTilt() function.
%
function [tilt] = TiltVectorSum(varargin)

	% Sum up the input tilt rotations using a vectorial method
	Num = length(varargin);
	if Num <= 0
		tilt = [0 0];
	elseif Num == 1
		tilt = varargin{1};
		if tilt(2) < 0
			tilt(1) = tilt(1);
			tilt(2) = -tilt(2);
		end
		tilt(1) = wrap(tilt(1));
	else
		polar = varargin{1};
		sum = polar(2)*[cos(polar(1)) sin(polar(1))];
		for k = 2:Num
			polar = varargin{k};
			sum = sum + polar(2)*[cos(polar(1)) sin(polar(1))];
		end
		tilt = [atan2(sum(2),sum(1)) sqrt(sum(1)*sum(1) + sum(2)*sum(2))];
	end

end
% EOF