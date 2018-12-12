clc;
close all;
clear all;
tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the optimal control for the cost function
% J = beta/2*integral(u^2) + 1/2*|| sum_i( x(T, nu(i)) ) - xtarget ||^2
% subject to:
% dx/dt = A(nu(i))*x + B(nu(i))*u
% x(0) = x0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size of state vector
N = 4;
% Initial condition
x0 =random('Gamma',5,10,N,1);

L = (1/N)*ones(N, N);
for i = 1:N
        L(i,i)=-1;
end

% Parameter beta for the cost function
beta = 1e-3;
% Initial and final time
T0 = 0; 
T = 1;
% Number of time steps (To discretize the integral) and time vector
Nt = 50;
tout = linspace(T0, T, Nt);
% Maximum number of iterations, iteration counter and tolerance (We stop when one of both criterium holds)
Nmax = 100;
tol = 0.00001;
% Initial gradient step (Notice that in stochastic in each step it shall to change)
% u = u + d*Duz

nn = 0.5; %(There are some literature about this)

u = zeros(Nt,N);
nerror=zeros(Nmax,1);

Du = zeros(Nt, N);
error=10;
iter=0;
d0=1;
d=d0;


while (error> tol && iter < Nmax)
    % Update iteration counter
    iter = iter + 1;
    
    pM = zeros(Nt, N);
    % Solve primal problem for every parameter in nu
    
  
    
   [tout, xout] = ode45(@(t, x) L*x + interp1(tout, u, t)', tout, x0);
        
        samples = datasample(1:N, 1, 'replace',false);

            
            p0=(xout(end,samples)*ones(1,N)-xout(end,:));
         
            
            [tout, pout] = ode45(@(t, p) L*p, tout, p0); 
            pM = pM + pout;
            pM = flipud(pM);
            ua=u;
            Du = beta*u-pM ;
            u= u - d*Du;
            d = d0/iter^nn; 
   
    error=0;
    for j=1
        error=error+(xout(end,j)-xout(end,i))^2;
    end
    error=error/N;
    nerror(iter)=error;
    fprintf('Iteration %i - Error %g - step %g\n', iter, error, i);
    
end   
  

xM = zeros(Nt, N);
for j = 1:N 

   [tout, xout] = ode45(@(t, x) L*x + interp1(tout, u, t)', tout, x0); 
   
end



toc


