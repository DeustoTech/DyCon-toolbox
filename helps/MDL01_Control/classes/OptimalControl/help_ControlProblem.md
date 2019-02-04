
# ./imgs-matlab/help_ControlProblem



```matlab
clear;
```


first define symbolics vectors:



![$$ symY = \\left( \\begin{matrix}   y1 \\\\
                                  y2
                 \\end{matrix} \\right) $$](./imgs-matlab/help_ControlProblem_eq16899647242732457595.png)




![$$ symU = \\left( \\begin{matrix}   u1 \\\\
                                  u2
                  \\end{matrix} \\right) $$](./imgs-matlab/help_ControlProblem_eq04942597875809680023.png)



We will use symbolic variables to define them.



```matlab
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',2);
```


In this case we will define the following differential equation



```matlab
Y0 = [  0; ...
       +1 ];
%
A = [ -1  1  ;  ...
       0 -2 ];
%
B = [  1 0; ...
       0 1 ];
```



```matlab
Fsym  = A*symY + B*symU;
```


To do this, we create an object differential equation. We can do it with the ODE constructor, in the following way:



```matlab
odeEqn = ode(Fsym,symY,symU,Y0);
```


Create the Funcional



```matlab
YT = [ 1; ...
       4];

symPsi  = (YT - symY).'*(YT - symY);
symL    = 0.0001*(symU.'*symU);

Jfun = Functional(symPsi,symL,symY,symU);
```


Now can create the object ControlProblem



```matlab
iCP1 = ControlProblem(odeEqn,Jfun);
iCP1
```




```

iCP1 = 

  ControlProblem with properties:

        Jfun: [1x1 Functional]
         ode: [1x1 ode]
           T: 1
          dt: 0.1000
    UOptimal: []


```


Solve Gradient



```matlab
GradientMethod(iCP1)
```




