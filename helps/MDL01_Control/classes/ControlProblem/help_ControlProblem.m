%% 
clear;
%%
% first define symbolics vectors:
%%
% $$ symY = \\left( \\begin{matrix}   y1 \\\\
%                                   y2 
%                  \\end{matrix} \\right) $$
%%
% $$ symU = \\left( \\begin{matrix}   u1 \\\\
%                                   u2 
%                   \\end{matrix} \\right) $$
%%
% We will use symbolic variables to define them.
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',2);
%%
% In this case we will define the following differential equation

Y0 = [  0; ...
        1 ] ;
%
A = [ -1  1  ;  ...
       0 -2 ];
%  
B = [  1 0; ...
       0 1 ];
%%
Fsym  = A*symY + B*symU;
%%
% To do this, we create an object differential equation.
% We can do it with the ODE constructor, in the following way:

odeEqn = ode(Fsym,symY,symU,Y0);

%%
% Create the Funcional  
YT = [ 1; ... 
       4];

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.0001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);

%%
% Now can create the object ControlProblem
iCP1 = ControlProblem(odeEqn,Jfun);
iCP1
%%
% Solve Gradient

GradientMethod(iCP1)
