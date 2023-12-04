% Wrap angle in radians to (-pi,pi]
function [out] = wrap(in)
	PI = GetPI(in);
	out = in + 2*PI*floor((PI - in)/(2*PI));
end
% EOF