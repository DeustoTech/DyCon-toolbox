clear;
%%              symU = [ u1 u2 ]
syms t
%% Discretizacion del espacio
%% Los vectores symY = [ y1 y2 y3 .. yn  ]


symY = SymsVector('y',2);
symU = SymsVector('u',1);
%% Creamos Funcional

A = 10;
symPsi  = 0;
symL    = A*(symU.'*symU) + symY(2);

Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%

S0 = 100;
I0 = 15;

Y0 = [ S0 ; ...
       I0];
%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%
Lambda = 1;
beta = 0.5;
sigma1 = 0.1;
sigma2 = 0.1;

S = symY(1);
I = symY(2);
Fsym(1)  = Lambda - beta*S*I -  sigma1*S; 
Fsym(2)  = beta*S*I - symU(1)*I - sigma2*I ;

Fsym = Fsym.';
%%%%%%%%%%%%%%%%
T = 20;
odeEqn = ode(Fsym,symY,symU,'Y0',Y0,'T',T);


%% Veamos que queremos 

solve(odeEqn)


%% Creamos Problema de Control

iCP1 = ControlProblem(odeEqn,Jfun);

%% Solve Gradient
DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',1e-5,'MinLengthStep',1e-10};
Gradient_Parameters = {'maxiter',50,'DescentParameters',DescentParameters,'Graphs',true,'TypeGraphs','ODE'};
%
GradientMethod(iCP1,Gradient_Parameters{:})

