% TestPlotCsys.m - Philipp Allgeuer - 05/11/14
% Tests:   PlotCsys
% Assumes: Rand*
%
% function [Pass] = TestPlotCsys(N, Tol, Inter)
%
% N     ==> Number of test cases to use in each test
% Tol   ==> Numeric tolerance to use for testing
% Inter ==> Boolean flag whether to also run interactive tests
% Pass  ==> Boolean flag whether all tests were passed

% Main function
function [Pass] = TestPlotCsys(N, Tol, Inter)

	% Process function inputs
	if nargin < 1 || ~isscalar(N) || N < 1
		N = 1;
	end
	N = min(round(N),1000000);
	if nargin < 2 || Tol <= 0
		Tol = 128*eps;
	end

	% Begin test script
	P = BeginTestScript('TestPlotCsys', N, Tol);

	%
	% Interactive testing
	%

	% Run the interactive testing component
	if Inter
		BeginTest('Interactive');
		B = BeginBoolean();
		B = B && TestPlotCsysInter();
		P = P & EndBoolean(B);
		P = P & EndTest();
	end

	%
	% End of test script
	%

	% End test script
	EndTestScript('TestPlotCsys', P);

	% Set the output pass flag
	if nargout >= 1
		Pass = P;
	end

	% Clear the function variable workspace
	if isOctave
		clear -x Pass
	else
		clearvars -except Pass
	end

end

% Interactive testing component
function [B] = TestPlotCsysInter()

	% Initialise variables
	B = true;
	h = [];

	% Plot 1
	h = [h figure()];
	PlotCsys;
	hold on;
	PlotCsys(RandRotmat,'R');
	PlotCsys(RandQuat,'Q');
	hold off;
	title('PlotCsys: Plot 1');
	xlabel('x \rightarrow');
	ylabel('y \rightarrow');
	zlabel('z \rightarrow');
	grid on;
	disp('Plot 1 should contain:');
	disp(' - Identity csys with labels {x,y,z}');
	disp(' - Random csys with labels {x_R,y_R,z_R}');
	disp(' - Random csys with labels {x_Q,y_Q,z_Q}');
	disp(' ');

	% Plot 2
	h = [h figure()];
	PlotCsys(eye(3),'G',[0 0 0],3);
	hold on;
	PlotCsys(RandRotmat,'R',[-2 2 1]);
	PlotCsys(RandQuat,'Qs',[1 -1 0],[2 1 1.5]);
	hold off;
	title('PlotCsys: Plot 2');
	xlabel('x \rightarrow');
	ylabel('y \rightarrow');
	zlabel('z \rightarrow');
	grid on;
	disp('Plot 2 should contain:');
	disp(' - Identity csys of size 3 with labels {x_G,y_G,z_G}');
	disp(' - Random csys of size 1 centered at [-2 2 1] with labels {x_R,y_R,z_R}');
	disp(' - Random csys of size [2 1 1.5] centered at [1 -1 0] with labels {x_Qs,y_Qs,z_Qs}');
	disp(' ');

	% Plot 3
	h = [h figure()];
	PlotCsys(eye(3),'G');
	hold on;
	PlotCsys(RandRotmat,'rand',[0 0 0]',1,'LineWidth',2.0);
	PlotCsys(RandRotmat,'D',[0 0 0],1,'LineWidth',1.5,'LineStyle','--');
	hold off;
	title('PlotCsys: Plot 3');
	xlabel('x \rightarrow');
	ylabel('y \rightarrow');
	zlabel('z \rightarrow');
	grid on;
	disp('Plot 3 should contain:');
	disp(' - Identity csys with labels {x_G,y_G,z_G}');
	disp(' - Random csys with linewidth 2.0 and labels {x_rand,y_rand,z_rand}');
	disp(' - Random csys with linewidth 1.5, dashed linestyle and labels {x_D,y_D,z_D}');
	disp(' ');

	% Wait for the user to appreciate the interactive testing
	fprintf('Press enter to close any opened figures and continue...');
	pause;
	fprintf('\n');
	for f = h
		if ishandle(f)
			close(f);
		end
	end
	pause(0.3);

end
% EOF