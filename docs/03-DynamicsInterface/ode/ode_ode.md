
# tp8dcc3eb2_414e_4d5c_a18e_05ff28cc4c81


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
```


And create a object ode



```matlab
iode = ode(Fs,xs,us,tspan);
```



```matlab
iode
```




```

iode = 

  ode with properties:

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



