
clear all


N = 50;
A = FDLaplacian(N);

xline =linspace(-1,1,N);

FinalState = 0.2*sin(pi*xline);

InvP = InverseProblem(A,FinalState);


InvP.dynamics.FinalTime = 0.5;
InvP.adjoint.dynamics.FinalTime = 0.5;


GradientMethod(InvP)