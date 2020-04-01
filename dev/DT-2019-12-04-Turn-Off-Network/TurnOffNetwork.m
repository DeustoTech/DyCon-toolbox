%% Optimal Control Problem with CasADi on a constrained fractional heat control.
% This code needs the installation of CasADi 3.4.5:
% https://web.casadi.org/get/
%%
% The object of this code is to reproduce the simulation of AMPL (and
% IpOpt) with CasADi (and IpOpt) in Matlab.
%%
% We start with the same problem as the DyCon Blog post,
% https://deustotech.github.io/DyCon-Blog/tutorial/wp03/WP03-P0022
% which deals with the one-dimensional fractional heat equation under
% positivity constraints:
% $$
% \begin{cases}
% z_t+(-d_x^2)^s z = u\chi_{\omega}, & (x,t)\in (-1,1)\times(0,T)
% \\
% z = 0, & (x,t)\in (-1,1)^c\times(0,T)
% \\
% z(\cdot,0)=z_0, & x\in (-1,1).
% \end{cases}
% $$
%%
% Following the post, the control region $\omega\subset (-1,1)$ as
% $(0.3,0.8)$ and $s = 0.8$. We will consider the problem of steering the
% initial datum:
% $$
% z_0(x) = \frac 12\cos\left(\frac \pi2 x\right)
% $$
%%
% to the target trajectroy $\widehat{z}$ solution with initial datum
% $$
% \widehat{z}_0(x) = 6\cos\left(\frac \pi2 x\right)
% $$
% and right-hand side $\widehat{u}\equiv 1$, where we state the following
% problem: 
% Initial data : $z_0$, Target data : $\widehat{z}_T(x)$, Final time :
% $0.4$, constraint : $u \geq 0$. 

%% Problem formulation
% Parameters for the problem

clear 
Nx = 10; % Space discretization
Nt = 100; % Time discretization : need to check the CFL condition
C = 1; % Bound on the control below
xi = -1; xf = 1; % Domain of the problem
s = 0.8; % The order of the fractional Laplacian
a = -0.3; b = 0.8; % Control region
T = 0.4; % Final time

% Discretization of the Space
xline = linspace(xi,xf,Nx+2);
xline = xline(2:end-1);
dx = xline(2) - xline(1);

Y0 = 0.5*cos(0.5*pi*xline'); % Initial data of the given trajectory
Y1 = 6.0*cos(0.5*pi*xline'); % Initial data of the target trajectory


% Discretization of the fractional Laplacian with finite element method
A = -FEFractionalLaplacian(s,1,Nx);
% Discretization of the control
B = BInterior(xline,a,b,'min',false);

% Discretization of the time : we need to check CFL condition to change 'Nt'.
tline = linspace(0,T,Nt+1);

%% Optimization problem
opti = casadi.Opti();  % CasADi function

% ---- Input variables ---------
X = opti.variable(Nx,Nt+1); % state trajectory
U = opti.variable(Nx^2,Nt);   % control
f = @(x,u) (u.*A)*x; % dx/dt = f(x,u)

% ---- Dynamic constraints --------
for k=1:Nt % loop over control intervals
   % Euler forward method
   x_next = X(:,k) + (T/Nt)*f(X(:,k),reshape(U(:,k),Nx,Nx)); 
   opti.subject_to(X(:,k+1)==x_next); % close the gaps
end

% for k=1:Nt % loop over control intervals
%    % Runge-Kutta 4 integration
%    k1 = f(X(:,k),         U(:,k));
%    k2 = f(X(:,k)+(T/Nt)/2*k1, U(:,k));
%    k3 = f(X(:,k)+(T/Nt)/2*k2, U(:,k));
%    k4 = f(X(:,k)+(T/Nt)*k3,   U(:,k));
%    x_next = X(:,k) + (T/Nt)/6*(k1+2*k2+2*k3+k4); 
%    opti.subject_to(X(:,k+1)==x_next); % close the gaps
% end

% ---- Control constraints -----------
opti.subject_to(0.1<=U(:));           % control is limited
opti.subject_to(1>=U(:));           % control is limited

% ---- State constraints --------
opti.subject_to(X(:,1)==Y0);

% ---- Optimization objective  ----------
Cost = 1e-6*sum(sum(abs(U))) + (X(:,Nt+1))'*(X(:,Nt+1));
opti.minimize(Cost); % minimizing L2 at the final time

% ---- initial guesses for solver ---
%opti.set_initial(X, repmat(Y0,[1 Nt+1]));
opti.set_initial(U, 1);

% ---- solve NLP              ------
opti.solver('ipopt'); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc
%% Post-processing
UControl = sol.value(U);

surf(reshape(UControl(:,1),Nx,Nx))