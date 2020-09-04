
# tp26a1de64_6566_4d25_9955_b6706f83e392


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
```



```matlab
u0 = ZerosControl(iode);
```



```matlab
u0
```




```

u0 = 

@1=0, 
[[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1], 
 [@1, @1, @1, @1, @1, @1, @1, @1, @1, @1]]

```



```matlab
class(u0)
```




```

ans =

    'casadi.SX'


```



