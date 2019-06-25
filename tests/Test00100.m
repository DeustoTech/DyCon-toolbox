%% A Continuous Stirred-Tank Chemical Reactor 
% Kirt Optimal Control Theory 
% Example 6.2-2 Page 338
JBook = 0.0268;

% Dynamics 
syms x1 x2 u t

Cexp  = (x2 +0.5)*exp((25*x1)/(x1+2));
% 
dx1dt = -2*(x1 + 0.25) + Cexp  - (x1 + 0.25)*u;
dx2dt =     0.5  - x2  - Cexp;

dXdt = [dx1dt; dx2dt];
X    = [x1;x2];

Params = sym.empty;
dXdt_fd = matlabFunction(dXdt,'Vars',{t,X,u,Params});
idyn = ode('DynamicEquation',dXdt_fd,'StateVector',X,'Control',u);
idyn.InitialCondition = [0.05 ;0];
idyn.FinalTime = 0.78;
idyn.Solver = @eulere;
idyn.Nt = 50;
% Functional 

Psi = @(T,Y) 0;
L   = @(t,X,U) X(1)^2 + X(2)^2 + 0.1*U^2;
iCP = Pontryagin(idyn,Psi,L,'CheckDerivative',true);

U0 = ones(idyn.Nt,1);
warning('Off')
[UOpt{1}, JOpt(1)] = GradientMethod(iCP,U0,'DescentAlgorithm',@AdaptativeDescent,'display','none');
%
[UOpt{2}, JOpt(2)] = GradientMethod(iCP,U0,'DescentAlgorithm',@ClassicalDescent,'display','none');
%
[UOpt{3}, JOpt(3)] = GradientMethod(iCP,U0,'DescentAlgorithm',@ConjugateDescent,'display','none');
%
JOpt(4) = JBook;
tol = 1e-2;
% 
assert(sum(pdist(JOpt','euclidean') > tol) == 0);

warning('On')

%% 