clear;
%% Los vectores symX = [ x1 x2 ]
%%              symU = [ u1 u2 ]
syms t

symX = SymsVector('x',2);
symU = SymsVector('u',2);
%% Creamos Funcional  
XT = [ 1; ... 
       4];

symPsi  = (XT - symX).'*(XT - symX);
symL    = 0.0001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symX,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%
X0 = [  0; ...
       +1 ];
%%%%%%%%%%%%%%%%
A = [ -1 1  ;  ...
      0 -2 ];
%%%%%%%%%%%%%%%%  
B = [ 1 0; ...
      0 1];
%%%%%%%%%%%%%%%%
Fsym  = A*symX + B*symU;
%%%%%%%%%%%%%%%%
odeEqn = ode(Fsym,symX,symU,X0);

%% Creamos Problema de Control

iCP1 = ControlProblem(odeEqn,Jfun);

%% Solve Gradient
T = 5;
GradientMethod(iCP1,T)



