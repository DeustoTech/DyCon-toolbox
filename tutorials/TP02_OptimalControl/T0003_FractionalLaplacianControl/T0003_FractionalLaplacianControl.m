clear;
%% Los vectores symY = [ y1 y2 ]
%%              symU = [ u1 u2 ]
syms t
%% Discretizacion del espacio
N = 10;
s = 0.8;
xi = -1; xf = 1;
xline = linspace(xi,xf,N);
a = -0.3; b = 0.5;

symY = SymsVector('y',N);
symU = SymsVector('u',N);
%% Creamos Funcional

YT = 0.0*sin(pi*xline)';

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%

Y0 = 2+2*cos(pi*xline)';
%%%%%%%%%%%%%%%%

%rho = 1000;
A = -FractionalLaplacian(s,1,N);
%%%%%%%%%%%%%%%%  
B = construction_matrix_B(xline,a,b);
%%%%%%%%%%%%%%%%
Fsym  = A*symY + B*symU;
%%%%%%%%%%%%%%%%
T = 0.3;
odeEqn = ode(Fsym,symY,symU,'Y0',Y0,'T',T);


%% Veamos que queremos 

solve(odeEqn)

line(xline,YT,'Color','red')
line(xline,odeEqn.Y(end,:),'Color','blue')
legend('Target','Free Dynamics')

%% Creamos Problema de Control

iCP1 = ControlProblem(odeEqn,Jfun,'T',T);

%% 
Solve Gradient
tol = 0.001;
DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',0.000001};

%
GradientMethod(iCP1,'tol',tol,'DescentParameters',DescentParameters,'graphs',true,'TypeGraphs','PDE','MaxIter',500)
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)

% iCP1.ode
