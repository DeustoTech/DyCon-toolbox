clear;
%% Los vectores symY = [ y1 y2 ]
%%              symU = [ u1 u2 ]
syms t
%% Discretizacion del espacio
N = 20;
xi = 0; xf = 1;
xline = linspace(xi,xf,N);

symY = SymsVector('y',N);
symU = SymsVector('u',2);
%% Creamos Funcional

YT = 4*sin(pi*xline)';

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%

Y0 = 2*sin(pi*xline)';
%%%%%%%%%%%%%%%%

rho = 1000;
A = rho*laplacian1d(N);
%%%%%%%%%%%%%%%%  
B = zeros(N,2);
B(1,1) = 1;
B(N,2) = 1;
%%%%%%%%%%%%%%%%
Fsym  = A*symY + B*symU;
%%%%%%%%%%%%%%%%
T = 20;
odeEqn = ode(Fsym,symY,symU,'Y0',Y0,'T',T);


%% Veamos que queremos 

solve(odeEqn)

line(xline,YT,'Color','red')
line(xline,odeEqn.Y(end,:),'Color','blue')
legend('Target','Free Dynamics')

%% Creamos Problema de Control

iCP1 = ControlProblem(odeEqn,Jfun,'T',5);

%% Solve Gradient
DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',2.0};
Gradient_Parameters = {'maxiter',10,'DescentParameters',DescentParameters,'Graphs',true,'Ugraphs','X'};
%
GradientMethod(iCP1,Gradient_Parameters{:})
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)


