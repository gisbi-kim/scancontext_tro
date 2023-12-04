% PlotCsys.m - Philipp Allgeuer - 05/11/14
% Plot an XYZ coordinate system in the currently active 3D plot.
%
% function PlotCsys(R, label, P, L, varargin)
%
% The coordinate system axes are plotted at point P (3D coordinate), and with
% orientation given by the rotation matrix R. L is a 3-vector that specifies
% the lengths of the individual axes (e.g. the x-axis is drawn from -L(1) to
% L(1)). If L is a scalar then the same length is used for all three axes.
% Axis labels are drawn if the label (string) parameter is non-zero. The string
% value is used as the axis subscripts. Custom arguments such as marker
% specifications can be forwarded to the internal plot3 function calls using
% the variable input arguments. If a quaternion is passed via the R parameter
% instead of a rotation matrix, this is detected and the quaternion is
% internally converted into a rotation matrix for processing.
%
% R        ==> Rotation matrix or quaternion to plot the axes of
% label    ==> String to use for the axis label subscripts (e.g. use 'G' for x_G)
% P        ==> The origin at which to plot the coordinate axes
% L        ==> The axis lengths to use for plotting
% varargin ==> Custom line graphics properties to set in all internal calls to plot3

% Main function
function PlotCsys(R, label, P, L, varargin)

	% Default argument values
	if nargin < 1
		R = eye(3);
	end
	if nargin < 2
		label = '';
	end
	if nargin < 3
		P = [0 0 0];
	end
	if nargin < 4
		L = [1 1 1];
	end

	% Convert the input to a rotation matrix if it's a quaternion
	if size(R,1) == 1 && size(R,2) == 4
		R = RotmatFromQuat(R);
	end

	% Check parameter sizes and values
	if isscalar(L)
		L = [L L L];
	end
	L = abs(L);
	L = L(:)';
	P = P(:)';
	if any(size(R) ~= 3)
		error('R doesn''t have the right dimensions for a rotation matrix or quaternion!');
	end
	if norm(R*R'-eye(3),'fro') > 1024*eps
		warning('R is not orthogonal to 1024*eps!');
	end

	% Generate the required plotting data
	LXAxis = [-L(1) 0 0;L(1) 0 0];
	LYAxis = [0 -L(2) 0;0 L(2) 0];
	LZAxis = [0 0 -L(3);0 0 L(3)];
	GXAxis = LocalToGlobal(LXAxis, P, R);
	GYAxis = LocalToGlobal(LYAxis, P, R);
	GZAxis = LocalToGlobal(LZAxis, P, R);

	% Generate the data required for the axes labels
	TSCL = L*1.1;
	LTLbl = diag(TSCL);
	GTLbl = LocalToGlobal(LTLbl, P, R);

	% Plot the required coordinate axes
	plot3(GXAxis(:,1),GXAxis(:,2),GXAxis(:,3),'r-',varargin{:}); % x => Red
	washeld = ishold;
	hold on;
	plot3(GYAxis(:,1),GYAxis(:,2),GYAxis(:,3),'-','Color',[0.15 0.70 0.15],varargin{:}); % y => Green
	plot3(GZAxis(:,1),GZAxis(:,2),GZAxis(:,3),'b-',varargin{:}); % z => Blue
	if any(label ~= 0) || isempty(label)
		if isempty(label)
			xlbl = 'x'; ylbl = 'y'; zlbl = 'z';
		else
			xlbl = ['x_{' label '}']; ylbl = ['y_{' label '}']; zlbl = ['z_{' label '}'];
		end
		text(GTLbl(1,1),GTLbl(1,2),GTLbl(1,3),xlbl,'Color','r','HorizontalAlignment','center'); % x => Red
		text(GTLbl(2,1),GTLbl(2,2),GTLbl(2,3),ylbl,'Color',[0.15 0.70 0.15],'HorizontalAlignment','center'); % y => Green
		text(GTLbl(3,1),GTLbl(3,2),GTLbl(3,3),zlbl,'Color','b','HorizontalAlignment','center'); % z => Blue
	end
	if ~washeld
		hold off;
	end

end

% Function that transforms local into global coordinates
function Global = LocalToGlobal(Local, P, R) % Local needs to be Nx3...
	Global = repmat(P,size(Local,1),1) + Local*R';
end
% EOF