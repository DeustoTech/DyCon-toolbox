%% define the state and control
 Y = sym('y',[2 1]); U = sym('u',[2 1]);
%%
% define your wierd dynamics
 F = [ - Y(2)      + U(1)        ; ...
       - sin(Y(1))     ] ;
% 
 dynamics = ode(F,Y,U);
 dynamics.Condition = [-1;1];

% A = [ -10 1; 0 -0.01];
% B = [1 ; 1];
% dynamics = ode('A',A,'B',B);
% dynamics.Condition = [1;1];
% dynamics.dt = 0.01;
% % define your functional 
% U = dynamics.Control.Symbolic;
% Y = dynamics.VectorState.Symbolic;

YT = [4;4]
Psi = (Y- YT).'*(Y-YT); 
L   = 0.1*(U.'*U);
% Creace de OptimalControl Object 
iP = OptimalControl(dynamics,Psi,L);


% Solve 
% GradientMethod(iP,'DescentParameters',{'MiddleStepControl',false,'InitialLengthStep',1e-10},'Graphs',true,'tol',1e-10,'MaxIter',500)
%GradientMethod(iP,'Graphs',true)

GradientMethod(iP,'Graphs',true)

