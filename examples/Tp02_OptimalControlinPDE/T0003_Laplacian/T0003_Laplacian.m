%% Parametros de discretizacion
N = 100;
xi = -1; xf = 1;
xline = linspace(xi,xf,N);
dx = xline(2) - xline(1);
%% Creamos el ODE 
A = FDLaplacian(xline);
%%%%%%%%%%%%%%%%  
a = -0.5; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%%%%%%%%%%%%%%%
FinalTime = 0.3;
dt = 0.001;
Y0 =sin(pi*xline)';

dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',50);
dynamics.mesh= xline;
%% Creamos Problema de Control
Y = dynamics.StateVector.Symbolic;
U = dynamics.Control.Symbolic;

YT = 0.0*xline';
epsilon = dx^4;
symPsi  = dx*(1/(2*epsilon))*(YT - Y).'*(YT - Y);
symL    = 0.5*dx*(U.'*U);
%symL     dx* 1/2*sum(abs(U));


iCP1 = Pontryagin(dynamics,symPsi,symL);

%% Solve Gradient
tol = 1e-6;
%
U0 = zeros(iCP1.Dynamics.Nt,iCP1.Dynamics.Udim);
GradientMethod(iCP1,U0,'tol',tol,'Graphs',false,'DescentAlgorithm',@ConjugateDescent,'MaxIter',200,'display','all')
%% fmincon
options = optimoptions(@fminunc,'display','iter','SpecifyObjectiveGradient',true);
Uopt = fminunc(@(U) Control2Functional(iCP1,U),U0,options)

%%

solve(iCP1.Dynamics,'Control',Uopt)
%%
dynamics.label = 'Free';
iCP1.Dynamics.label = 'with Control';
solve(dynamics)

plotT([iCP1.Dynamics dynamics])
hold on 
plot()
% animation([iCP1.ode,dynamics],'YLim',[-1 1],'xx',0.05)
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)

% iCP1.ode
%%
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
