
# tp071cf411_7c6c_4f36_bf5a_a932f8672529



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
[uopt,xopt] = ConjugateGradient(iocp,uguess);
```




```
iteration: 005 | error: 2.473e+03 | norm(dJ): 2.473e+03 | LengthStep: +2.762e-07 | beta: 1.093e+00 | J: 1.9944e+03 | Distance2Target: NaN 
iteration: 010 | error: 2.997e+03 | norm(dJ): 2.997e+03 | LengthStep: +1.976e-07 | beta: 1.073e+00 | J: 1.9937e+03 | Distance2Target: NaN 
iteration: 015 | error: 3.521e+03 | norm(dJ): 3.521e+03 | LengthStep: +1.609e-07 | beta: 1.063e+00 | J: 1.9930e+03 | Distance2Target: NaN 
iteration: 020 | error: 4.065e+03 | norm(dJ): 4.065e+03 | LengthStep: +1.405e-07 | beta: 1.057e+00 | J: 1.9922e+03 | Distance2Target: NaN 
iteration: 025 | error: 4.638e+03 | norm(dJ): 4.638e+03 | LengthStep: +1.278e-07 | beta: 1.053e+00 | J: 1.9913e+03 | Distance2Target: NaN 
iteration: 030 | error: 5.248e+03 | norm(dJ): 5.248e+03 | LengthStep: +1.195e-07 | beta: 1.049e+00 | J: 1.9902e+03 | Distance2Target: NaN 
iteration: 035 | error: 5.897e+03 | norm(dJ): 5.897e+03 | LengthStep: +1.138e-07 | beta: 1.047e+00 | J: 1.9889e+03 | Distance2Target: NaN 
iteration: 040 | error: 6.586e+03 | norm(dJ): 6.586e+03 | LengthStep: +1.098e-07 | beta: 1.044e+00 | J: 1.9874e+03 | Distance2Target: NaN 
iteration: 045 | error: 7.312e+03 | norm(dJ): 7.312e+03 | LengthStep: +1.070e-07 | beta: 1.042e+00 | J: 1.9855e+03 | Distance2Target: NaN 
iteration: 050 | error: 8.066e+03 | norm(dJ): 8.066e+03 | LengthStep: +1.049e-07 | beta: 1.039e+00 | J: 1.9833e+03 | Distance2Target: NaN 

```



```matlab
uopt
```




```

uopt =

   -2.6217   -2.6272   -2.5285   -2.2421   -1.6369   -0.5107    1.4475


```



```matlab
xopt
```




```

xopt =

    1.0000    0.6188    0.3006    0.0606   -0.0738   -0.0560    0.1892
    2.0000    1.5773    1.2206    0.9230    0.6830    0.5053    0.4026


```



