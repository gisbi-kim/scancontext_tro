% EulerFromZVec.m - Philipp Allgeuer - 21/10/16
% Converts a z-vector to the corresponding zero ZYX yaw Euler angles representation.
%
% function [Euler] = EulerFromZVec(ZVec)
%
% It is assumed that ZVec is a unit vector!
%
% ZVec  ==> Input z-vector
% Euler ==> Corresponding zero ZYX yaw Euler angles rotation

% Main function
function [Euler] = EulerFromZVec(ZVec)

	% Extract the sin of the theta angle
	sth = max(min(-ZVec(1),1.0),-1.0); % Note: If ZVec is a unit vector then this should only trim at most a few eps...

	% Calculate the required Euler angles
	Euler = [0 asin(sth) atan2(ZVec(2),ZVec(3))];

end
% EOF