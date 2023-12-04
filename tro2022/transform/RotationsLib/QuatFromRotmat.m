% QuatFromRotmat.m - Philipp Allgeuer - 05/11/14
% Converts a rotation matrix to the corresponding quaternion representation.
%
% function [Quat] = QuatFromRotmat(Rotmat)
%
% The output quaternion is in the format [w x y z].
% Note that Quat and -Quat are both valid and completely equivalent outputs
% here, so we have the freedom to arbitrarily choose the sign of *one* of
% the quaternion parameters during the conversion. At the end of the
% conversion here, we change the sign of the whole quaternion so that the
% w component is non-negative.
%
% Rotmat ==> Input rotation matrix
% Quat   ==> Equivalent quaternion rotation

% Main function
function [Quat] = QuatFromRotmat(Rotmat)

	% Calculate a scaled version of the required quaternion
	t = Rotmat(1,1) + Rotmat(2,2) + Rotmat(3,3);
	if t >= 0
		qtilde = [1+t Rotmat(3,2)-Rotmat(2,3) Rotmat(1,3)-Rotmat(3,1) Rotmat(2,1)-Rotmat(1,2)];
	elseif Rotmat(3,3) >= Rotmat(2,2) && Rotmat(3,3) >= Rotmat(1,1)
		qtilde = [Rotmat(2,1)-Rotmat(1,2) Rotmat(1,3)+Rotmat(3,1) Rotmat(3,2)+Rotmat(2,3) 1-Rotmat(1,1)-Rotmat(2,2)+Rotmat(3,3)];
	elseif Rotmat(2,2) >= Rotmat(1,1)
		qtilde = [Rotmat(1,3)-Rotmat(3,1) Rotmat(2,1)+Rotmat(1,2) 1-Rotmat(1,1)+Rotmat(2,2)-Rotmat(3,3) Rotmat(3,2)+Rotmat(2,3)];
	else
		qtilde = [Rotmat(3,2)-Rotmat(2,3) 1+Rotmat(1,1)-Rotmat(2,2)-Rotmat(3,3) Rotmat(2,1)+Rotmat(1,2) Rotmat(1,3)+Rotmat(3,1)];
	end

	% Normalise the output quaternion
	Quat = qtilde / norm(qtilde);

	% Ensure that the w component is non-negative (not strictly speaking necessary, as Quat is actually entirely equivalent to -Quat as a rotation)
	if Quat(1) < 0
		Quat = -Quat;
	end

end
% EOF