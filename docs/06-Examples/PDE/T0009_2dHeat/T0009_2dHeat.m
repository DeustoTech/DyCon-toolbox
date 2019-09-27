clear;

Nx = 10;    Ny = 15;
%
xline = linspace(-1,1,Nx+2); xline = xline(2:end-1); dx = xline(2) - xline(1);
yline = linspace(-1,1,Ny+2); yline = yline(2:end-1); dy = yline(2) - yline(1);
% 
A = FDLaplacial2D(xline,yline);

%% Dynamics

dynamics = pde('A',A);
dynamics.mesh = {xline,yline};
dynamics.FinalTime = 2;
% time points
Nt = 30;
dynamics.Nt =Nt;

%% Select Initial Condition
[Xms,Yms] = meshgrid(xline,yline);
Initms = Xms.^2 + Yms.^2;

dynamics.InitialCondition    =  reshape(Initms,Nx*Ny,1);

%% Compute Target
solve(dynamics)
FinalState =  dynamics.StateVector.Numeric(end,:);


%% Build Inverse Problem - dynamics and FinalState mamdatory
InvP = InverseProblem(dynamics,FinalState);

dx = xline(2) - xline(1);
InvP.gamma = dx^4;
%% Can add constraints in Init Condition
InvP.Constraints.MinControl = 0;
InitControl = FinalState*0;

%GradientMethod(InvP,InitControl)
GradientMethod(InvP,InitControl,'display','all','tol',1e-9,'DescentAlgorithm',@ClassicalDescent)

%InitControl = FinalState*0;
%GradientMethod(InvP,InitControl,'display','all','tol',1e-9,'DescentAlg