%%
% Solves the fractional Schrodinger equation 
%% 
% $$
% \begin{cases}
% iu_t + (-d_x^2)^s u = 0, &  (x,t) \in (-L,L)\times(0,T)  \\
%
% u = 0,                   &  (x,t) \in (-L,L)\times(0,T)  \\
%
% u(x,0) = u0(x),          &   x \in (-L,L)   
% \end{cases}$$
%%
% using FE for the approximation of the fractional 
% Laplacian and Cranck-Nicholson for the time integration 
%% 
% For this example we choose following parameters 
s = 0.5;
N = 100;
L = 1;
%% 
% Execute the function
A = rigidity_fr_laplacian(s,L,N);
%% 
% Can see graphically representation of matrix
figure(1)
mesh(A) 
view(155,100)
