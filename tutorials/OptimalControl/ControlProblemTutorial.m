clear;
%% Los vectores symY = [ y1 y2 ]
%%              symU = [ u1 u2 ]
syms t

symY = SymsVector('y',2);
symU = SymsVector('u',2);
%% Creamos Funcional  
YT = [ 1; ... 
       4];

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.0001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%
Y0 = [  0; ...
       +1 ];
%%%%%%%%%%%%%%%%
A = [ -1 1  ;  ...
      0 -2 ];
%%%%%%%%%%%%%%%%  
B = [ 1 0; ...
      0 1];
%%%%%%%%%%%%%%%%
Fsym  = A*symY + B*symU;
%%%%%%%%%%%%%%%%
T = 5;

odeEqn = ode(Fsym,symY,symU,Y0,'T',T);

%% Creamos Problema de Control
iCP1 = ControlProblem(odeEqn,Jfun);

%% Solve Gradient

GradientMethod(iCP1,'Graphs',true)

% view res
%  animation(odeEqn)
% animation(odeEqn,'YLim',[-2 5],'xx',2.0)
