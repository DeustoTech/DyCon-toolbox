%%
% Instead of the Gradient method in the DyCon Toolbox, we may use Matlab
% built-in functions such as 'fmincon' or 'fminunc' for the optimizations.
% In this tutorial, we test 'fmincon' and 'GradientMethod' with the example
% 'Problem 6.3' in the following paper:
%
% [1] : E. R. Edge and W. F. Powers. "Function-space quasi-Newton
% algorithms for optimal control problems with bounded controls and
% singular arcs." Journal of Optimization Theory and Applications 20.4
% (1976): 455-479.
%
%%
clear

syms x1 x2 x3 x4 u1 t

Y = [x1; x2; x3; x4];
U = [u1];

A = [-0.5,      5,    0,    0;
       -5,   -0.5,    0,    0;
        0,      0, -0.6,   10;
        0,      0,  -10, -0.6];

B = [0; 1; 0; 1];

dynamics = A*Y + B*U;
dynamics = matlabFunction(dynamics,'Vars',{t,Y,U,sym.empty});

%%
% We choose solver 'ode23tb' to cover the stiff nature of the equations.

iode = ode(dynamics,Y,U);
% setting ODE
iode.InitialCondition = [10; 10; 10; 10];
iode.FinalTime        = 4.2;
iode.Nt               = 100;
%% Free
[~,YGuess] = solve(iode);
UGuess = iode.Control.Numeric;
%% 
% We Create the Optimal Control Problem 
%% 
% 
Psi = @(t,Y) (Y'*Y);
L   = @(t,Y,U) 0;

iCP = Pontryagin(iode,Psi,L);
%
iCP.Constraints.MaxControl = +1;
iCP.Constraints.MinControl = -1;

%%
% After we defined 'Pontryagin' class, we may use the function
% 'Control2Functional' to indicate the cost as a function of the control.
% In this way, we may impliment 'fmincon'. The maximum and minimum of the
% control are given by -1 and 1.

% U0 = iode.Control.Numeric;
% Umax = 1*ones(size(iode.Control.Numeric));
% Umin = -1*ones(size(iode.Control.Numeric));
% options = optimoptions(@fmincon,'display','iter','SpecifyObjectiveGradient',true);
% [U1_tspan,J1_optimal] = fmincon(@(U)Control2Functional(iCP,U),U0,[],[],[],[],Umin,Umax,[],options);
% 

%%
% We can solve the same control problem using 'GradientMethod'.
%
[U1 ,J1,Y1] =  DiscreteProblemFmincon(iCP,'ControlGuess',UGuess + 1,'StateGuess',YGuess+ 2);
%
[U2 ,J2,Y2] = GradientMethod(iCP,UGuess,'Graphs',false,'DescentAlgorithm',@AdaptativeDescent,'display','all');
%
%%
plot(iode.tspan,[U1,U2])
xlabel('Time')
ylabel('Control')
legend(['Solution of fmincon, cost=',num2str(J1)],['Solution of GradientMethod, cost=',num2str(J2)])
