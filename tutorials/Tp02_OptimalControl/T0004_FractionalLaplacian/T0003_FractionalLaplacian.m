%% Parametros de discretizacion
N = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,N);

%% Creamos el ODE 

s = 0.8;
A = -FEFractionalLaplacian(s,1,N);
%%%%%%%%%%%%%%%%  
a = -0.3; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%%%%%%%%%%%%%%%
FinalTime = 0.5;
Y0 =sin(pi*xline)';

dynamics = ode('A',A,'B',B,'Condition',Y0,'FinalTime',FinalTime,'dt',0.01);

%% Creamos Problema de Control
Y = dynamics.VectorState.Symbolic;
U = dynamics.Control.Symbolic;

YT = 0.0*xline';

symPsi  = (YT - Y).'*(YT - Y);
symL    = 0*(U.'*U);
iCP1 = OptimalControl(dynamics,symPsi,symL);

%% Solve Gradient
tol = 0.000001;
DescentParameters = {'InitialLengthStep',5.0};

%
GradientMethod(iCP1,'tol',tol,'DescentParameters',DescentParameters,'graphs',true,'TypeGraphs','PDE')

solve(dynamics)

iCP1.ode.label = 'Control';
dynamics.label = 'Dynamics';
animation([iCP1.ode,dynamics],'YLim',[-1 1],'xx',0.01)
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)

% iCP1.ode
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
