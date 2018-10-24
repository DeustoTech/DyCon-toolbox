---
  layout: function
  categories: Documentation
  title: fractional_schr
  author: UmbertoB
  date: 2017-04-01
  short_description: Solver the fractional Schrodinger equation in 1d 
  inputs_variables:  
    s:
        type:        double
        dimension:   1
        description: Order of the fractional Laplacian (-dx^2)^s
        WARNING:     s HAS TO BE CHOSEN IN THE INTERVAL (0,1) 
    L:
        type:         double
        dimension:    1
        description:  Define the interval of x, So x \in (-L,L)  
    N:
        type:        integer
        dimension:   1
        description: number of points in the space discretization 
    T:
        type:        double
        dimension:   1
        description: length of the time interval
    u0:
        type:        function handle
        dimension:   1
        description: initial datum u0(x)
  outputs_variables:
    x:
        type:        double
        dimension:   1x(N+2)
        description: space partition
    t:
        type:        double
        dimension:   1xNt (Nt defined applying the CFL condition)
        description: time partition
    u:
        type:        double
        dimension:   NxNt
        description: solution of the equation
---
<hr>
## Description


Solves the fractional Schrodinger equation


$$ \begin{cases} iu_t + (-d_x^2)^s u = 0, &  (x,t) \in (-L,L)\times(0,T)  \\


u = 0,                   &  (x,t) \in (-L,L)\times(0,T)  \\


u(x,0) = u0(x),          &   x \in (-L,L) \end{cases}$$


using FE for the approximation of the fractional Laplacian and Cranck-Nicholson for the time integration


For this example we choose following parameters



```matlab
s = 0.5;
N = 100;
L = 1;
```


Execute the function



```matlab
A = rigidity_fr_laplacian(s,L,N);
```


Can see graphically representation of matrix



```matlab
figure(1)
mesh(A)
view(155,100)
```


![](./../assets/imgs/functions/fractional_schr/help_file_01.png)



