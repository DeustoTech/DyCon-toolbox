%% define the state and control
 Y = sym('y',[2 1]); U = sym('u',[1 1]);
%%
% define your wierd dynamics
 F = [ Y(2)             ; ...
      -Y(2)      + U(1) ] ;
% 
dynamics = ode(F,Y,U);
dynamics.Condition = [0;-1];
dynamics.dt = 0.01;
% A = [ -10 1; 0 -0.01];
% B = [1 ; 1];
% dynamics = ode('A',A,'B',B);
% dynamics.Condition = [1;1];
% dynamics.dt = 0.01;
% % define your functional 
% U = dynamics.Control.Symbolic;
% Y = dynamics.VectorState.Symbolic;

YT = [4;4]
Psi = sym(0);
L   = 0.005*(U.'*U) +  Y.'*Y ;
% Creace de OptimalControl Object 
iP = OptimalControl(dynamics,Psi,L);


% Solve 
GradientMethod(iP)
plot(iP)
%%
% alpha = constant
% u + alpha*du
GradientMethod(iP,'DescentAlgorithm',@ClassicalDescent)

% Solve by Conjugate Gradient
% http://web.mit.edu/mitter/www/publications/2_conjugate_grad_IEEEAC.pdf 

% 
GradientMethod(iP)
plot(iP)
plot(iP)
% Is more fast