% AngVelFromQuatTime.m - Philipp Allgeuer - 06/04/17
% Convert a quaternion rotation plus time into the corresponding angular velocity vector
%
% function [AngVel] = AngVelFromQuatTime(dt, QuatB, QuatA)
%
% QuatA and QuatB are rotations relative to global coordinates.
% If QuatA is not provided, the quaternion rotation QuatB is converted to an angular velocity.
% If QuatA is provided, the global quaternion rotation from QuatA to QuatB is converted to an
% angular velocity, that is, QuatB*inv(QuatA) is converted instead of just QuatB.
% The angular velocity vector is always expressed in global coordinates.
%
% dt    ==> The time of the rotation
% QuatB ==> Input quaternion rotation B (assumed to have unit norm)
% QuatA ==> Input quaternion rotation A (assumed to have unit norm)

% Main function
function [AngVel] = AngVelFromQuatTime(dt, QuatB, QuatA)

	% Input arguments
	if nargin < 3
		Quat = QuatB;
	else
		Quat = QuatMult(QuatB, QuatInv(QuatA));
	end
	if Quat(1) < 0
		Quat = -Quat;
	end

	% Calculate the angular velocity direction
	vec = Quat(2:4);
	vecnorm = sqrt(vec(1)*vec(1) + vec(2)*vec(2) + vec(3)*vec(3));
	if vecnorm <= 0
		AngVel = [0 0 0];
		return
	end
	vec = vec / vecnorm;

	% Calculate the angular velocity magnitude
	theta = 2*atan2(vecnorm, Quat(1));

	% Construct the output angular velocity
	AngVel = theta*vec/dt;

end
% EOF