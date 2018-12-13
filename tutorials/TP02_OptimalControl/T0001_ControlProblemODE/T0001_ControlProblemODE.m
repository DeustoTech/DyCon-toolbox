
%% 
% En este tutorial veremos como utilizar la implementacion para el control optimo en 
% la DyConLib, para ello es necesario definir algunas notaciones. Dado que el control optimo viene definido 
% como un problema de optimizacion con una restriccion, la ecuacion diferencial. Seguiremos la notación utiliza da 
% en el artículo [Pontryagin Maximum Principle](https://en.wikipedia.org/wiki/Pontryagin%27s_maximum_principle#Formal_statement_of_necessary_conditions_for_minimization_problem)
clear;
%%
% Los vectores 
%%
% $$ symY = \left( \begin{matrix}   y1 \\
%                                   y2 
%                  \end{matrix} \right) $$
%%
% $$ symU = \left( \begin{matrix}   u1 \\
%                                   u2 
%                   \end{matrix} \right) $$
%%
% Utilizaremos variable simbolicas para definirlos 
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',2);
%%
% Das las Creamos el ODE 
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

% Creamos Funcional  
YT = [ 1; ... 
       4];

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.0001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);



%% Creamos Problema de Control
iCP1 = ControlProblem(odeEqn,Jfun);

%% Solve Gradient

GradientMethod(iCP1)

% view res
%  animation(odeEqn)
%%
% ![](extra-data/081472.gif)

% animation(odeEqn,'YLim',[-2 5],'xx',2.0)
