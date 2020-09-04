
# tp8fbf9883_6481_49bc_8808_43a685c3e907


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
Fs = casadi.Function('F',{ts,xs,us},{ - xs(1) + us(1);
                                      - xs(2) + us(2)});
tspan = linspace(0,1,100);
xline = linspace(0,1,100);
```


And create a object ode



```matlab
ipde1d = pde1d(Fs,xs,us,tspan,xline);
```



```matlab
ipde1d
```




```

ipde1d = 

  pde1d with properties:

               xline: [1x100 double]
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



