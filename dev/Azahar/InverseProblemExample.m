clear all
%% Dynamics

N = 100;

xline =linspace(-12,12,N);
A = FDLaplacian(xline);

dynamics = pde('A',A);
dynamics.mesh = xline;
dynamics.FinalTime = 2;
Nt = 30;
dynamics.dt = dynamics.FinalTime/Nt;

%% Select Initial Condition
dynamics.InitialCondition    =   -(10/12)*sign(xline).*xline + 10;
dynamics.InitialCondition   =   -(10/144)*xline.^2 + 10;
%dynamics.InitialCondition    =   0*xline;
%dynamics.InitialCondition(10) = 3;
%dynamics.InitialCondition(20:36) = 5;
%dynamics.InitialCondition(80) = 8;
%dynamics.InitialCondition(3) = 50;

%% Compute Target
solve(dynamics)
FinalState =  dynamics.StateVector.Numeric(end,:);


%% Build Inverse Problem - dynamics and FinalState mamdatory
InvP = InverseProblem(dynamics,FinalState);

dx = xline(2) - xline(1);
InvP.gamma = dx^4;
%% Can add constraints in Init Condition
%InvP.constraints.Umin = 0;

GradientMethod(InvP)
%GradientMethod(InvP,'display','all','tol',1e-9,'DescentAlgorithm',@ConjugateDescent,'DescentParameters',{'StopCriteria','JDiff'})
%GradientMethod(InvP,'display','all','tol',1e-9,'DescentAlgorithm',@ClassicalDescent,'DescentParameters',{'FixedLengthStep',false})