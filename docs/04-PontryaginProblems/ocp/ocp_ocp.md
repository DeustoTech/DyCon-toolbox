
# tp91f3e2f5_7a59_4a25_b866_a874de4ee8a9



```matlab
clear all;close all
import casadi.*

Xs = SX.sym('x',2,1);
Us = SX.sym('u',2,1);
ts = SX.sym('t');
%
A = [ -2 +1;
      +1 -2];

B = [1 0;
     0 1];
```



```matlab
EvolutionFcn = Function('f',{ts,Xs,Us},{ A*Xs + B*Us });
%
tspan = linspace(0,2,10);
iode = ode(EvolutionFcn,Xs,Us,tspan);
SetIntegrator(iode,'RK4')
iode.InitialCondition = [1;2];
```



```matlab
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(iode,PathCost,FinalCost)
```




```

iocp = 

  ocp with properties:

      DynamicSystem: [1x1 ode]
            CostFcn: [1x1 CostFcn]
       VariableTime: 0
        constraints: [1x1 constraints]
        TargetState: []
        Hamiltonian: [0x0 casadi.Function]
      AdjointStruct: [1x1 AdjointStruct]
    ControlGradient: [1x1 casadi.Function]


```



