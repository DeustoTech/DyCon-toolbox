
# tp4f76170c_441b_47a6_8ba3_93b281655cfe



```matlab
import casadi.*

A = [-2  1;
      1 -2];
B = [1;0];
%
tspan = linspace(0,1,7);
idyn = linearode(A,B,tspan);
idyn.InitialCondition = [1;2];
```



```matlab
ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(idyn,PathCost,FinalCost);
```



```matlab
uguess = tspan;
[uopt,xopt] = SteptestGradientDescent(iocp,uguess);
```




```
iteration: 005 | error: 3.672e+03 | LengthStep: 8.705e-04 | J: 1.234e+03 | Distance2Target: NaN 
iteration: 010 | error: 2.642e+02 | LengthStep: 2.640e-04 | J: 5.972e+01 | Distance2Target: NaN 
iteration: 015 | error: 1.706e+02 | LengthStep: 1.358e-04 | J: 5.118e+01 | Distance2Target: NaN 
iteration: 020 | error: 3.506e+01 | LengthStep: 1.806e-04 | J: 4.304e+01 | Distance2Target: NaN 
iteration: 025 | error: 2.688e+01 | LengthStep: 2.964e-06 | J: 4.304e+01 | Distance2Target: NaN 
iteration: 030 | error: 2.658e+01 | LengthStep: 3.377e-07 | J: 4.304e+01 | Distance2Target: NaN 
iteration: 035 | error: 2.655e+01 | LengthStep: 4.453e-08 | J: 4.304e+01 | Distance2Target: NaN 

    Mininum Length Step have been achive !! 


```



```matlab
uopt
```




```

uopt =

   -7.9333   -8.1012   -7.8269   -6.7884   -4.4855   -0.1486    7.3999


```



```matlab
xopt
```




```

xopt =

    1.0000   -0.0763   -0.9101   -1.4598   -1.6275   -1.2375   -0.0019
    2.0000    1.4905    1.0041    0.5706    0.2245    0.0137    0.0100


```



