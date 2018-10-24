---
  layout: function
  categories: Documentation
  title: rigidity_fr_laplacian
  author:   UmbertoB
  date:     2017-04-01
  short_description: Compute the rigidity matrix for the FE discretization of the fractional Laplacian  $(-dx^2)^s \in (-L,L)$.
  long_description:  Puedo poner lo que sea $\alpha$ Me va a dej       Puedo poner lo que sea $\alpha$ Me va a deja
  inputs_variables:  
    s:
        type:        double
        dimension:   1
        description: Fractional Order of laplacian $(-dx^2)^s$
    L:
        type:         double
        dimension:    1
        description:  Define the interval of x, So $x \in (-L,L)$  
    N:
        type:        integer
        dimension:   1
        description: number of points of discretitation 
  outputs_variables:
    A:
        type:        double
        dimension:   NxN
        description: Rigidity Matrix of fractional Laplacian
---


Choose following parameters



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


![](./../assets/imgs/functions/help_rigidity_fr_laplacian_01.png)



