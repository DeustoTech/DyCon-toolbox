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
Y = sym('y',[2 1])
%%
U = sym('u',[1 1])
%%
% The dynamics of $ Y $ should be given by a symbolic vector with the same
% dimensions as the state vector. Following the notation at the beginning,
% this vector represents $ f (t, Y, U) $:
 F = @(t,Y,U) [      Y(1)*Y(2)          ; ...
                -Y(2) + U(1) ] ;
%% 
% Using this dynamics vector, we construct an 'ode' class.
dynamics = ode(F,Y,U)
%%
% The printed information above shows the default setting of this 'ode'
% class. In order to construct the dynamics we want, we need to customize
% its parameters. In this case we change the initial condition for the
% dynamics and the sampling timestep.
%%
% The time discretization is generated as a uniform mesh from the timestep
% $ dt $. It will be used not only for the sampling of the state vector $ Y
% $ but also to represent the control vector $ U $ and cost $ J $ in
% 'OptimalControl' class. 
dynamics.InitialCondition = [0;-1];
dynamics.Nt = 10;
%%
% Next we need to define the functional $ J $ we want to minimize.
% Following the form presented in [1], we define the expressions of $ \ Psi $
% and $ L $ in symbolic form:
Psi = @(T,Y)   Y.'*Y;
L   = @(t,Y,U) 0.005*(U.'*U)+Y.'*Y ;
%%
% We finally define the optimal control problem as a 'OptimalControl' class:
iP = Pontryagin(dynamics,Psi,L);
%%
% This class contains information we need to find the optimal control
% vector $ U $. It is worth mentioning that until now we defined the
% problem but not solved it yet.
iP
%%
% DyCon toolbox uses the gradient methods to optimize the cost functional. 
% This calculates the gradient of $ J $ along $ U $ from the first order
% approximation of the Hamiltonian and adjoint state vector in the
% Pontryagin principle.
%%
% To solve the problem using the default gradient method, we simply write:
U0 = zeros(iP.Dynamics.Nt,iP.Dynamics.ControlDimension);
GradientMethod(iP,U0);
%% 
% This command generates 'solution' in the 'OptimalControl' class, which
% contains the optimal control vector 'UOptimal' and its information, such as the
% cost, precision and time of computations.
iP.Solution
%%
% This structure is independent of the solver, and we can see the results
% through visualization functions we want. One of the examples is 'plot'
% function which can be applied to 'OptimalControl' class.
plot(iP)
