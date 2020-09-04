
# tp1363a577_be7f_4bb8_beb2_e29bca9939a4


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
tspan = linspace(0,1,10);
```


And create a object ode



```matlab
iode = ode(Fs,xs,us,tspan);
SetIntegrator(iode,'RK4')
iode.InitialCondition = [1;1];
```



```matlab
u0 = ZerosControl(iode);
xt = solve(iode,u0);
```



```matlab
xt
```




```

xt = 


[[1, 0.867043, 0.751763, 0.65181, 0.565147, 0.490007, 0.424857, 0.368369, 0.319392, 0.276926], 
 [1, 0.929876, 0.864669, 0.804035, 0.747653, 0.695225, 0.646473, 0.60114, 0.558985, 0.519787]]

```



```matlab
class(xt)
```




```

ans =

    'casadi.DM'


```



