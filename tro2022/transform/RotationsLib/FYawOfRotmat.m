% FYawOfRotmat.m - Philipp Allgeuer - 05/11/14
% Calculates the fused yaw of a rotation matrix.
%
% function [FYaw] = FYawOfRotmat(Rotmat)
%
% Rotmat ==> Input rotation matrix
% FYaw   ==> Fused yaw of the input rotation

% Main function
function [FYaw] = FYawOfRotmat(Rotmat)

	% Calculate the fused yaw of the rotation
	t = Rotmat(1,1) + Rotmat(2,2) + Rotmat(3,3);
	if t >= 0.0
		FYaw = 2*atan2(Rotmat(2,1)-Rotmat(1,2), 1+t);
	elseif Rotmat(3,3) >= Rotmat(2,2) && Rotmat(3,3) >= Rotmat(1,1)
		FYaw = 2*atan2(1-Rotmat(1,1)-Rotmat(2,2)+Rotmat(3,3), Rotmat(2,1)-Rotmat(1,2));
	elseif Rotmat(2,2) >= Rotmat(1,1)
		FYaw = 2*atan2(Rotmat(3,2)+Rotmat(2,3), Rotmat(1,3)-Rotmat(3,1));
	else
		FYaw = 2*atan2(Rotmat(1,3)+Rotmat(3,1), Rotmat(3,2)-Rotmat(2,3));
	end
	FYaw = wrap(FYaw);

end
% EOF