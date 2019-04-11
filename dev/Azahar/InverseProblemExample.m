clear all
%% Dynamics

N = 100;

xline =linspace(-12,12,N);
A = FDLaplacian(xline);

dynamics = pde('A',A);
dynamics.mesh = xline;
dynamics.FinalTime = 1;
Nt = 30;
dynamics.dt =dynamics.FinalTime/Nt;

%% Select Initial Condition
dynamics.InitialCondition    =   -(10/12)*sign(xline).*xline + 10;
%dynamics.InitialCondition   =   -(10/144)*xline.^2 + 10;
dynamics.InitialCondition    =   0*xline;
dynamics.InitialCondition(10) = 3;
dynamics.InitialCondition(30) = 5;
dynamics.InitialCondition(80) = 8;
dynamics.InitialCondition(20) = 10;

%% Compute Target
solve(dynamics)
FinalState =  dynamics.StateVector.Numeric(end,:);


%%
InvP = InverseProblem(dynamics,FinalState);
%InvP.constraints.Umin = 0;
GradientMethod(InvP,'display','all','tol',1e-9)