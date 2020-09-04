
# tp028d5980_905c_4709_9b25_0946787d562a


Create a symbolical variable



```matlab
clear
import casadi.*
xs = SX.sym('x',2,1);
us = SX.sym('u',2,1);
ts = SX.sym('t');
```


Define a dynamic as casadi Function



```matlab
Fs = casadi.Function('F',{ts,xs,us},{ [- 2*xs(1) + us(1) ;
                                      - xs(2) + us(2)]    });
tspan = linspace(0,1.5,7);
```


And create a object ode



```matlab
iode = ode(Fs,xs,us,tspan);
iode.InitialCondition = [1;1];
u0 = ZerosControl(iode);
```



```matlab
iode.tspan = linspace(0,0.5,7);
SetIntegrator(iode,'RK4')
xt_RK4 = solve(iode,u0)
```




```

xt_RK4 = 

@1=1, 
[[@1, 0.897602, 0.805689, 0.723187, 0.649134, 0.582664, 0.523], 
 [@1, 0.946689, 0.89622, 0.848441, 0.80321, 0.76039, 0.719853]]

```



```matlab
iode.tspan = linspace(0,0.5,7);
SetIntegrator(iode,'RK8')
xt_RK8 = solve(iode,u0)
```




```

xt_RK8 = 

@1=1, 
[[@1, 0.846482, 0.716531, 0.606531, 0.513417, 0.434598, 0.367879], 
 [@1, 0.920044, 0.846482, 0.778801, 0.716531, 0.659241, 0.606531]]

```



```matlab
iode.tspan = linspace(0,0.5,7);
SetIntegrator(iode,'BackwardEuler')
xt_BE  = solve(iode,u0)
```




```

xt_BE = 

@1=1, 
[[@1, 0.833333, 0.694444, 0.578704, 0.482253, 0.401878, 0.334898], 
 [@1, 0.916667, 0.840278, 0.770255, 0.706067, 0.647228, 0.593292]]

```



