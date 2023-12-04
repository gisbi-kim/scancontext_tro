% QuatFromFYawTilt.m - Philipp Allgeuer - 04/05/17
% Calculates the frame B with a given fused yaw relative to G and tilt rotation component relative to H.
%
% function [qHB, qGB] = QuatFromFYawTilt(FYawG, TiltH, qGH)
%
% FYawG ==> Desired fused yaw of B relative to G
% TiltH ==> Specification of the desired tilt rotation component of B relative to H
%           Can be any quaternion [w x y z] with the required tilt rotation component
%           (i.e. any qHC that has the same tilt rotation component as the desired qHB)
%           Can be any tilt angles [psi gamma alpha] with the required tilt rotation component
%           Can be a direct tilt rotation component specification [gamma alpha]
% qGH   ==> Relative quaternion rotation between G and H
% qHB   ==> Output quaternion rotation from H to B
% qGB   ==> Output quaternion rotation from G to B

% Main function
function [qHB, qGB] = QuatFromFYawTilt(FYawG, TiltH, qGH)

	% Retrieve the reference quaternion with the required tilt rotation component
	N = numel(TiltH);
	if N == 2
		qHC = QuatFromTilt([0 TiltH(1) TiltH(2)]);
	elseif N == 3
		qHC = QuatFromTilt(TiltH);
	elseif N == 4
		qHC = TiltH;
	else
		error('Invalid TiltH argument!');
	end

	% Precompute trigonometric values
	chpsi = cos(FYawG/2);
	shpsi = sin(FYawG/2);

	% Construct the base components of the solution
	a = qGH(2)*qHC(2) + qGH(3)*qHC(3);
	b = qGH(2)*qHC(3) - qGH(3)*qHC(2);
	c = qGH(1)*qHC(4) + qGH(4)*qHC(1);
	d = qGH(1)*qHC(1) - qGH(4)*qHC(4);
	A = d - a;
	B = b - c;
	C = b + c;
	D = d + a;
	G = D*chpsi - B*shpsi;
	H = A*shpsi - C*chpsi;
	F = sqrt(G*G + H*H);

	% Construct the z-rotation qHCB that maps C to the required B
	if F <= 0
		qHCB = [1 0 0 0];
	else
		chphi = G/F;
		shphi = H/F;
		qHCB = [chphi 0 0 shphi];
	end

	% Construct the output quaternions
	qHB = QuatMult(qHCB, qHC);
	if nargout >= 2
		qGB = QuatMult(qGH, qHB);
	end

end
% EOF