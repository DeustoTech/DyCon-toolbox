function iocp = P0001_OCProblem
%P0001_OCPROBLEM Linear problems 2D ode
import casadi.*

A = [-2 1;
      1 -2];

B = [1;0];
%
tspan = linspace(0,1,50);
idyn = linearode(A,B,tspan);
idyn.InitialCondition = [1;2];


ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(idyn,PathCost,FinalCost);

U0 = tspan;
IpoptSolver(iocp,U0)

end

