
# tpe9576988_d254_4391_a958_d51ee293b0a4



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
[uopt,xopt] = IpoptSolver(iocp,uguess);
```




```
This is Ipopt version 3.12.3, running with linear solver mumps.
NOTE: Other linear solvers might be more efficient (see Ipopt documentation).

Number of nonzeros in equality constraint Jacobian...:       62
Number of nonzeros in inequality constraint Jacobian.:        0
Number of nonzeros in Lagrangian Hessian.............:        9

Total number of variables............................:       21
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:       14
Total number of inequality constraints...............:        0
        inequality constraints with only lower bounds:        0
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        0

iter    objective    inf_pr   inf_du lg(mu)  ||d||  lg(rg) alpha_du alpha_pr  ls
   0  2.0000338e+04 1.00e+00 1.33e+01  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1  2.1420978e+01 3.33e-16 1.66e-14  -1.0 5.90e+00    -  1.00e+00 1.00e+00f  1

Number of Iterations....: 1

                                   (scaled)                 (unscaled)
Objective...............:   1.0710489227567338e-01    2.1420978455134676e+01
Dual infeasibility......:   1.6577017536434369e-14    3.3154035072868737e-12
Constraint violation....:   3.3306690738754696e-16    3.3306690738754696e-16
Complementarity.........:   0.0000000000000000e+00    0.0000000000000000e+00
Overall NLP error.......:   1.6577017536434369e-14    3.3154035072868737e-12


Number of objective function evaluations             = 2
Number of objective gradient evaluations             = 2
Number of equality constraint evaluations            = 2
Number of inequality constraint evaluations          = 0
Number of equality constraint Jacobian evaluations   = 2
Number of inequality constraint Jacobian evaluations = 0
Number of Lagrangian Hessian evaluations             = 1
Total CPU secs in IPOPT (w/o function evaluations)   =      0.006
Total CPU secs in NLP function evaluations           =      0.001

EXIT: Optimal Solution Found.
               t_proc [s]   t_wall [s]    n_eval
       nlp_f      3.3e-05      3.4e-05         2
       nlp_g      5.8e-05      5.8e-05         2
  nlp_grad_f     0.000101       0.0001         3
  nlp_hess_l      0.00807      6.2e-05         1
   nlp_jac_g     0.000236      0.00024         3
      solver       0.0208      0.00761         1
Elapsed time is 0.022389 seconds.

```



```matlab
uopt
```




```

uopt =

   -5.5768   -5.6623   -5.5679   -4.7070   -2.4409    2.3186    5.4928


```



```matlab
xopt
```




```

xopt =

    1.0000    0.1623   -0.5028   -0.9714   -1.1358   -0.7915   -0.0010
    2.0000    1.5116    1.0554    0.6485    0.3127    0.0857    0.0046


```



