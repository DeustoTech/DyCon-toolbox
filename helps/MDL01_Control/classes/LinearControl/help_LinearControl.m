
%% 
% First define the vectors
%%
% $$ symY = \left( \begin{matrix}   y1 \\
%                                   y2 
%                  \end{matrix} \right)
%    symU = \left( \begin{matrix}   u1 \\
%                                   u2 
%                   \end{matrix} \right) $$
%%
% We will use symbolic variables to define them.
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',2);
%%
% *Ordinary differential equation*
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
A = [ -1  1  ; 0 -2 ];
B = [  1  0  ; 0  1 ];
%%
% To do this, we create an object differential equation. We can do it with the ODE constructor, in the following way.
odeEqn = LinearODE(A,B);
Y0 = [  0;1 ];
odeEqn.Y0 = Y0; 
%%
% *Cost Functional*
%%
% $$ J = \Psi(Y(T),t) + \int_0^T L(Y(t,U),U(t),t) dt$$
%%
% For this, we choose a target of vector state  
YT = [ 1; 4];
%%
% Then, 
%%
% $$\Psi(Y,t) = \vert Y(T) - Y(t) \vert ^2 $$
%%
% $$ L(Y(t,U),U(t),t) = \beta \vert U(t) \vert^2$$
%%
symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.0001*(symU.'*symU);
%% 
% For last, you an create the functional object
Jfun = Functional(symPsi,symL,symY,symU);
%%
% Now, We can create the control problem
iCP1 = LinearControl(odeEqn,Jfun);
%%
% and solve by Classical Gradient Method
GradientMethod(iCP1)
%%
% Solve the equation without control
solve(odeEqn) 
plot(odeEqn)
%% 
% And compare the controlled solution
plot(iCP1.ode)


