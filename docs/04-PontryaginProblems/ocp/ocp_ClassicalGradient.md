
# tp75340942_bd19_4ee0_9eee_b314a14ad68b



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
[uopt,xopt] = ClassicalGradient(iocp,uguess);
```




```
iteration: 005 | error: 2.525e+03 | LengthStep: 1.000e-04 | J: 1.981e+03 | Distance2Target: NaN 
iteration: 010 | error: 2.253e+03 | LengthStep: 1.000e-04 | J: 1.688e+03 | Distance2Target: NaN 
iteration: 015 | error: 2.086e+03 | LengthStep: 1.000e-04 | J: 1.453e+03 | Distance2Target: NaN 
iteration: 020 | error: 1.933e+03 | LengthStep: 1.000e-04 | J: 1.252e+03 | Distance2Target: NaN 
iteration: 025 | error: 1.790e+03 | LengthStep: 1.000e-04 | J: 1.079e+03 | Distance2Target: NaN 
iteration: 030 | error: 1.658e+03 | LengthStep: 1.000e-04 | J: 9.315e+02 | Distance2Target: NaN 
iteration: 035 | error: 1.536e+03 | LengthStep: 1.000e-04 | J: 8.046e+02 | Distance2Target: NaN 
iteration: 040 | error: 1.423e+03 | LengthStep: 1.000e-04 | J: 6.957e+02 | Distance2Target: NaN 
iteration: 045 | error: 1.318e+03 | LengthStep: 1.000e-04 | J: 6.024e+02 | Distance2Target: NaN 
iteration: 050 | error: 1.221e+03 | LengthStep: 1.000e-04 | J: 5.223e+02 | Distance2Target: NaN 

```



```matlab
uopt
```




```

uopt = 

[[-4.66594, -4.75716, -4.63036, -4.11885, -2.96299, -0.762059, 3.09807]]

```



```matlab
xopt
```




```

xopt = 


[[1, 0.354971, -0.164069, -0.534352, -0.705436, -0.587689, -0.0341006], 
 [2, 1.54437, 1.13777, 0.786533, 0.501721, 0.302829, 0.222859]]

```



