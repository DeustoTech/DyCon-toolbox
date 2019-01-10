
%% 
% In this tutorial we will see how to use the implementation for optimal control in the DyCon Toolbox,
% for this it is necessary to define some notations. Since the optimal control is defined as an optimization 
% problem with a constraint, the differential equation. We will follow the notation used in the article Pontryagin
% Maximum Principle
clear;
%%
% The vectors
%%
% $$ symY = \left( \begin{matrix}   y1 \\
%                                   y2 
%                  \end{matrix} \right) $$
%%
% $$ symU = \left( \begin{matrix}   u1 \\
%                                   u2 
%                   \end{matrix} \right) $$
%%
% We will use symbolic variables to define them.
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',2);
%%
% ##  Ordinary differential equation
%%
% In this case we will define the following differential equation
%%
% $$ \dot{\textbf{Y}} = \left( \begin{matrix} 
%   -1  &  1 \\
%    0  & -2 \\
%   \end{matrix} \right) * \textbf{Y} + 
%   \left( \begin{matrix} 
%    1  &  0 \\
%    0  &  1 \\
%   \end{matrix} \right) * \textbf{U} 
% $$ 
A = [ -1  1  ;  ...
       0 -2 ];
%  
B = [  1 0; ...
       0 1 ];
%%
% To do this, we create an object differential equation. We can do it with the ODE constructor, in the following way.
odeEqn = LinearODE(A,B);
%%
Y0 = [  0; ...
       +1 ];
  
odeEqn.Y0 = Y0; 
%%
% ##  Cost Functional 
%%
% $$ J = \Psi(Y(T),t) + \int_0^T L(Y(t,U),U(t),t) dt$$
%%
% For this, we choose a target of vector state  
YT = [ 1; ... 
       4];
%%
% Then, 
%%
% $$\Psi(Y,t) = \abs{Y(T) - Y(t)}^2 $$
symPsi  = (YT - symY).'*(YT - symY);
%%
% and 
%%
% $$ L(Y(t,U),U(t),t) = \beta \abs{U(t)}^2$$
symL    = 0.0001*(symU.'*symU);
%% 
% For last, you an create the functional object
Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos Problema de Control
iCP1 = LinearControl(odeEqn,Jfun);

%% Solve Gradient

GradientMethod(iCP1)
%%
% ![](extra-data/081472.gif)
%%


% Resolvemos la ecuacion sin controlfree dynamics 
solve(odeEqn) 
% 
figure
plot(odeEqn.tline',odeEqn.Y(:,1),'Color','red')
line(odeEqn.tline',odeEqn.Y(:,2),'Color','green')
legend({'Y_1','Y_2'})
%% 
% La solucion obtenida en el metodo del gradiente es:
odec = iCP1.ode;
figure
plot(odec.tline',odec.Y(:,1),'Color','red')
line(odec.tline',odec.Y(:,2),'Color','green')
legend({'Y_1','Y_2'})


