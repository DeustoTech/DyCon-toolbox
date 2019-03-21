%% 
% DyCon toolbox adopts Pontryagin's maximum principle to optimize the
% control function for each control problem. In this way we can solve
% problems of the form:  
%%
% $$ \min_{U \in \Omega } \Psi(t,Y(T)) + \int_0^T L(t,Y,U) dt, $$
%%
% subject to
%%
% $$ \dot{Y} = f(t,Y,U). $$
%% 
% 'OptimalControl' class uses symbolic interface to define a control
% problem as in 'ode' class. 'OptimalControl' class contains 'ode' class,
% the final cost, and running cost. As 'ode' class contains $ f $, the
% final cost $ \Psi $ and running cost $ L $ should be given by symbolic
% functions. 
%% 
% Here we explain 'OptimalControl' class with a simple example: we want to
% minimize the objective function
%%
% $$ J (Y,U) := \int_0^2 (y_1^2 + y_2^2) + 0.005(u_1^2 + u_2^2) dt, $$
%% 
% subject to
%% 
% $$ \left( \begin{matrix}   
%       \dot{y_1} \\
%       \dot{y_2}
%     \end{matrix} \right)    =  
%     \left( \begin{matrix}   
%               y_2     \\ 
%               -y_2+u_1                
%      \end{matrix} \right) $$
%% 
% The dynamics and cost functions are based on symbolic vectors $ Y $ and $
% U $, which represent the state of the dynamics and control vector.
X = sym('x',[2 1]);
%%
U = sym('u',[1 1]);
%%
% The dynamics of $ Y $ should be given by a symbolic vector with the same
% dimensions as the state vector. Following the notation at the beginning,
% this vector represents $ f (t, Y, U) $:
 F = [ X(2)          ; ...
      -X(2) + U(1) ] ;
%% 
% Using this dynamics vector, we construct an 'ode' class.
dynamics = ode(F,X,U);
dynamics.InitialCondition = [1;-1];

dynamics.dt = 0.01;
%%
% Next we need to define the functional $ J $ we want to minimize.
% Following the form presented in [1], we define the expressions of $ \ Psi $
% and $ L $ in symbolic form:
Psi = sym(0);
L   = (X(1)-1)^2 + X(2)^2 + 0.005*U(1)^2;

%%
% We finally define the optimal control problem as a 'OptimalControl' class:
iP = OptimalControl(dynamics,Psi,L);

%%
% To solve the problem using the default gradient method, we simply write:
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent,'Graphs',true,'Display','all')
%% 
% This command generates 'solution' in the 'OptimalControl' class, which
% contains the optimal control vector 'UOptimal' and its information, such as the
% cost, precision and time of computations.
iP.solution
%%
% This structure is independent of the solver, and we can see the results
% through visualization functions we want. One of the examples is 'plot'
% function which can be applied to 'OptimalControl' class.
plot(iP)
