%%
% In this example, we present the use of class 'ode'. Here we solve the
% following simple system of ordinary differential equations:
%%
% $$ \begin{bmatrix}
% \dot{y}_1 \\
% \dot{y}_2
% \end{bmatrix} = \left(\begin{array}{c} u_{1}+\sin\left(y_{1}\,y_{2}\right)+y_{1}\,y_{2}\\ u_{2}+y_{2}+\cos\left(y_{1}\,y_{2}\right) \end{array}\right)
% $$
%%
% $$ y_1(1) = 1 / / y_2(1) = -1 $$
%%
% In DyCon toolbox, the use of symbolic variables is chosen to represent
% the dynamic equations. We first define a symbolic vector representing the
% solution states.

Y = sym('y',[2 1])
%%
% In addition, we define a symbolic vector for the control functions of
% the equation.

U = sym('u',[2 1])
%%
% Using these two variables, we can state the system by a symbolic
% expression of the vector field. 
F = [ sin(Y(1)*Y(2)) +    (Y(1)*Y(2)) + U(1)   ; ...
         Y(2)        + cos(Y(1)*Y(2)) + U(2) ] ;
dynamics = ode(F,Y,U);
%%
% In this way, we defined 'dynamics' of the class 'ode' which represents
% the following equation of a matrix form:
%%
% $$ \dot Y = F(Y,U). $$
%%
% Let's see what we have created
dynamics
%%
% DyCon toolbox creates a lot of default variables to represent the
% conditions of differential equations. We may see the information more
% heuristic way through the resume function:
resume(dynamics)
%%
% We also can directly modify its variables, for example, we may change the
% initial data:

dynamics.InitialCondition = [1,-1];
resume(dynamics)
%%
% 'solve' function solves the differential equation of 'ode'. The values of
% 'Y' are calculated according to the timeline and initial data. The MATLAB
% built-in function 'ode45' works as a default to solve the 'ode'.
solve(dynamics);
%%
% 'plot' function plots the states of 'Y', the vector of states. Note that
% this produces errors if 'solve' function is not operated.
plot(dynamics)
%%
% If the system is linear, then we can create the 'ode' class using the
% matrix. Along with the notion of linear control problem, the following
% code represents the system:
%%
% $$ \dot Y = AY + BU. $$

A = [ 0 -2 ; 2 0];
B = [1 ; 1];

dynamics_linear = ode('A',A,'B',B);
dynamics_linear.InitialCondition = [1,0];
solve(dynamics_linear);
plot(dynamics_linear)