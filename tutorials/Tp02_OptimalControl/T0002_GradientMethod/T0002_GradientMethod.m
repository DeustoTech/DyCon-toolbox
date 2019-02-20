%%
% Gradient method is an iterative method finding optimal arguments. In the
% optimal control problem, it wants to find the optimal control vector $ U
% $, in order to minimize the cost $ J $.
%%
% Hence, in order to improve the value $ J(U) $, gradient methods
% should estimate the directional derivative $ dJ = J_U(U) $ and update the
% control vector along this direction based on a previous control vector $
% U_{old} $. There are different types of descent algorithms to update the
% control from the data $ dJ $ and $ U_{old} $.
%%
% DyCon toolbox has three implemented methods to find a proper descent.
%
% - 'ClassicalDescent': After the gradient $ dJ $ is calculated, it updates
% the control in the following way:
% $$ u_ {new} = u_ {old} + \ alpha dJ, $$
% where $ \alpha $ is a constant.
%
% - 'AdaptativeDescent': It updates the control in the same way as in
% 'ClassicalDescent'. However, it first try the parameter $ \alpha $
% multiplied by two from the previous $ \alpha $ and check whether the
% value of $ J $ decreases. If not, it divide $ \alpha $ into half and
% check whether if the value of J decreases. In this way, proper $\alpha$
% will be determined to decrease $ J $ effectively along the direction $ dJ
% $. 
%
% - 'ConjugateGradientDescent': It updates the control as suggested in [1].
% It searches the direction of a linear combination between the gradient of
% the current control and the gradient of the previous control, in order to
% find a effective (conjugate) direction $ J $ decreases. For the step-size
% $ \alpha $, it calculate the minimal argument numerically using MATLAB
% built-in function.
%
% The default methods of 'OptimalControl' class is
% 'ConjugateGradientDescent'.
%
% [1] : L. Lasdon, S. Mitter, and A. Waren. "The conjugate gradient method
% for optimal control problems." IEEE Transactions on Automatic Control
% 12.2 (1967): 132-138.  
%
%%
% In this tutorial, we present the use of different gradient methods in
% DyCon toolbox. We will implement various descent schemes on the following
% example problem: Minimizing the cost function
%% 
% $$  \int_0^2 (y_1-2)^2 + (y_2-4)^2 + 0.005(u_1^2 + u_2^2) dt $$ 
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
% In order to construct 'OptimalControl' class, we define 'ode' class, the
% final cost 'Psi', and the running cost $ L(t,Y,U) $ using symbolic
% variables and functions. 

Y = sym('y',[2 1]); U = sym('u',[1 1]);

F = [ Y(2)             ; ...
      -Y(2)      + U(1) ] ;

dynamics = ode(F,Y,U); % Define 'ode' class
dynamics.Condition = [0;-1];
dynamics.dt = 0.01;

YT = [2;4];
Psi = sym(0);
L   =0.005*(U.'*U) + (Y-YT).'*(Y-YT);

iP = OptimalControl(dynamics,Psi,L); % Define 'OptimalControl' class

%%
% 'GradientMethod' solves the optimal control problem of 'OptimalControl'
% class. In order to specify a descent algorithm, we use 'DescentAlgorithm'
% parameter of 'GradientMethod' function:
GradientMethod(iP,'DescentAlgorithm',@ClassicalDescent)
plot(iP)
%%
GradientMethod(iP,'DescentAlgorithm',@AdaptativeDescent)
plot(iP)
%%
GradientMethod(iP,'DescentAlgorithm',@ConjugateGradientDescent)
plot(iP)