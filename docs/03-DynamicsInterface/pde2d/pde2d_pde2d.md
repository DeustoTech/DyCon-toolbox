
# tpa1b96b56_317c_4486_bdb8_83d4ed2aaed1


Create a symbolical variable



```matlab
clear
import casadi.*
us = SX.sym('u',2,1);
vs = SX.sym('v',2,1);
ts = SX.sym('t');
```


Define a dynamic as casadi Function



```matlab
Fs = casadi.Function('F',{ts,us,vs},{ - us(1) + vs(1);
                                      - us(2) + vs(2)});
tspan = linspace(0,1,100);
xline = linspace(0,1,100);
yline = linspace(0,1,100);
```


And create a object ode



```matlab
ipde2d = pde2d(Fs,us,vs,tspan,xline,yline);
```



```matlab
ipde2d
```




```

ipde2d = 

  pde2d with properties:

               xline: [1x100 double]
               yline: [1x100 double]
                 xms: [100x100 double]
                 yms: [100x100 double]
               tspan: [1x100 double]
                  ts: [1x1 casadi.SX]
          MassMatrix: [2x2 double]
              method: []
              solver: []
          DynamicFcn: [1x1 casadi.Function]
               State: [1x1 fun]
             Control: [1x1 fun]
    InitialCondition: [2x1 casadi.DM]
                  Nt: 100


```



