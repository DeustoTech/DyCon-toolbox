%% A Continuous Stirred-Tank Chemical Reactor 
% Kirt Optimal Control Theory 
% Example 6.2-2 Page 338
JBook = 0.0268;

% Dynamics 
syms x1 x2 u

Cexp  = (x2 +0.5)*exp((25*x1)/(x1+2));
% 
dx1dt = -2*(x1 + 0.25) + Cexp  - (x1 + 0.25)*u;
dx2dt =     0.5  - x2  - Cexp;

dXdt = [dx1dt; dx2dt];
X    = [x1;x2];

idyn = ode('DynamicEquation',dXdt,'StateVector',X,'Control',u);
idyn.InitialCondition = [0.05;0];
idyn.FinalTime = 0.78;

idyn.Nt = 100;
% Functional 

L = x1^2 + x2^2 + 0.1*u^2;
iCP = Pontryagin(idyn,sym(0),L);

U0 = ones(Nt,1);
warning('Off')
[UOpt{1}, JOpt(1)] = GradientMethod(iCP,U0,'DescentAlgorithm',@AdaptativeDescent,'display','none');

[UOpt{2}, JOpt(2)] = GradientMethod(iCP,U0,'DescentAlgorithm',@ClassicalDescent,'display','none');

[UOpt{3}, JOpt(3)] = GradientMethod(iCP,U0,'DescentAlgorithm',@ConjugateDescent,'display','none');


JOpt(4) = JBook;
% 
tol = 1e-2;
% 
assert(sum(pdist(JOpt','euclidean') > tol) == 0);

warning('On')

%% 