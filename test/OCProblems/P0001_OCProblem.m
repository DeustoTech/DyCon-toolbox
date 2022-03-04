function iocp = P0001_OCProblem
%P0001_OCPROBLEM Linear problems 2D ode
import casadi.*

A = [-2  1 ;
      1 -2];

B = [1;0];
%
tspan   = linspace(0,1,50);

ts = casadi.SX.sym('ts');
idyn    = linearode(A,B,ts,tspan);
%
idyn.InitialCondition = [1;2];

[ts,Xs,Us] = symvars(idyn);
%
PathCost  = Us'*Us;
FinalCost = 1e4*(Xs'*Xs);

iocp = ocp(idyn,PathCost,FinalCost);

U0 = tspan;
IpoptSolver(iocp,U0)

end

