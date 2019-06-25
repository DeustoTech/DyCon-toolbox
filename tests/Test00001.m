%% A Continuous Stirred-Tank Chemical Reactor 
% Kirt Optimal Control Theory 
% Example 6.2-2 Page 338
JBook = 0.0268;

% Dynamics 
syms x1 x2 u1 u2 t

A = [1 2;
     3 4];
 
B = [1 0;
     0 2;];
 
dXdt = @(t,X,U,Params) A*X + B*U;
X = [x1;x2];
U = [u1;u2];

idyn = ode('DynamicEquation',dXdt,'StateVector',X,'Control',U);
% Functional 

Psi = @(T,X)   X(1)^2 + X(2)^2; 
L   = @(t,X,U) U(1)^2 + U(2)^2;
iCP = Pontryagin(idyn,Psi,L);

%
P = sym('p',[2 1]);
XU = [X;U];

