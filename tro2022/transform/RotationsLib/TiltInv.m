% TiltInv.m - Philipp Allgeuer - 05/11/14
% Calculates the inverse of a tilt angles rotation.
%
% function [Tinv] = TiltInv(T)
%
% T    ==> Input tilt angles rotation
% Tinv ==> Inverse tilt angles rotation

% Main function
function [Tinv] = TiltInv(T)
	
	% Get the required value of pi
	PI = GetPI(T);

	% Calculate the inverse tilt axis angle
	gammainv = T(1) + T(2) - PI;
	gammainv = wrap(gammainv);

	% Construct the inverse rotation
	Tinv = [-T(1) gammainv T(3)];

end
% EOF