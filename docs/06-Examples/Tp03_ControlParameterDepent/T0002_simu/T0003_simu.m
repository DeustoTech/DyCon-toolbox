clear all
% In this case $\nu_i$ are
nu = linspace(1,6,10);
%nu = 1;
%%
% Size of state vector
N = 2;
M = length(nu);

Am = eye(N, N);
for i = 1:N
    for j = 1:N
        if j > i
            Am(i, j) = 1;
        end
    end
end
Am = -Am;

Bm = zeros(N, 1);
Bm(N) = 1;

A = zeros(M*N, M*N);
B = zeros(M*N, 1);
for j = 1:M
    Ainit = N*(j-1)+1;
    Aend  = N*j;
    
    A(Ainit:Aend,Ainit:Aend) = Am + (nu(j) - 1 )*diag(diag(Am));    
    B(Ainit:Aend, :) = Bm;
end

%%
%% Problem formulation
% Parameters for the problem
Nt = 150; % Time discretization : need to check the CFL condition
C = 1; % Bound on the control below
xi = -1; xf = 1; % Domain of the problem
s = 0.8; % The order of the fractional Laplacian
a = -0.3; b = 0.8; % Control region
T = 2.5; % Final time
% Discretization of the Space
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
dx = xline(2) - xline(1);

Y0 = ones(N, 1);
Y0 = repmat(Y0,M,1);

f = @(x,u) A*x+B*u; % dx/dt = f(x,u)

% Discretization of the fractional Laplacian with finite element method

% Discretization of the time : we need to check CFL condition to change 'Nt'.
tline = linspace(0,T,Nt+1);

% Discretization of the target trajectory

YT = zeros(N, 1); 
YT = repmat(YT,M,1);
%% Optimization problem
opti = casadi.Opti();  % CasADi function

% ---- Input variables ---------
X = opti.variable(M*N,Nt+1); % state trajectory
U = opti.variable(1,Nt);   % control

% ---- Dynamic constraints --------
for k=1:Nt % loop over control intervals
   % Euler forward method
   x_next = X(:,k) + (T/Nt)*f(X(:,k),U(:,k)); 
   opti.subject_to(X(:,k+1)==x_next); % close the gaps
end


% ---- Control constraints -----------

% ---- State constraints --------
opti.subject_to(X(:,1)==Y0);
opti.subject_to(U(:)<=10*ones(Nt,1));
opti.subject_to(U(:)>=-10*ones(Nt,1));

% ---- Optimization objective  ----------
Cost = (X(:,Nt+1)-YT)'*(X(:,Nt+1)-YT);
opti.minimize(Cost); % minimizing L2 at the final time

% ---- initial guesses for solver ---
%opti.set_initial(X, repmat(Y0,[1 Nt+1]));
opti.set_initial(U, 0);

% ---- solve NLP              ------
opti.solver('ipopt'); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc
%% Post-processing
close all
figure
plot(sol.value(X)')
figure
plot(sol.value(U)')
