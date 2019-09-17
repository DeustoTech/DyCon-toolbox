%% Optimal Control Problem with CasADI on a constrained fractional heat control. 
% This code needs the installation of CasADI:
% https://web.casadi.org/get/
%%
% The object of this code is to reproduce the simulation of AMPL (and
% IpOpt) with CasADI (and IpOpt) in Matlab.
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
% Initial data : $z_0 - \widehat{z}_0(x)$, target point : $0$, constraint :
% $u \geq -1$. 

%% Problem formulation
% Parameters for the problem
Nx = 20; % Space discretization
Nt = 200; % Time discretization
Y0 = 0.5*cos(0.5*pi*xline'); % Initial data of the given trajectory
Y1 = 6.0*cos(0.5*pi*xline'); % Initial data of the target trajectory
C = 1; % Bound on the control below
xi = -1; xf = 1; % Domain of the problem
s = 0.8; % The order of the fractional Laplacian
a = -0.3; b = 0.8; % Control region

% Discretization of the Space
xline = linspace(xi,xf,Nx+2);
xline = xline(2:end-1);
dx = xline(2) - xline(1);

% Discretization of the fractional Laplacian with finite element method
A = -FEFractionalLaplacian(s,1,Nx);
M = MassMatrix(xline);
A = M\A;

% Discretization of the control
B = BInterior(xline,a,b,'min',false);
PB = B; % Projection to the effective control function.
Nx_u = Nx; % The size of control function
B = M\B;

% Discretization of the time : we need to check CFL condition to change 'Nt'.
FinalTime = 0.5; % Initial guess on the final time

%% Optimization problem
opti = casadi.Opti(); 

% ---- Input variables ---------
X = opti.variable(Nx,Nt+1); % state trajectory
U = opti.variable(Nx_u,Nt);   % control
T = opti.variable();      % final time

% ---- Dynamic constraints --------
f = @(x,u) A*x+B*u; % dx/dt = f(x,u)

for k=1:Nt % loop over control intervals
   % Euler forward method
   x_next = X(:,k) + (T/Nt)*f(X(:,k),U(:,k)); 
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
opti.subject_to(-C<=U(:));           % control is limited

% ---- State constraints --------
opti.subject_to(X(:,1)==Y0-Y1);
opti.subject_to(X(:,Nt+1)==0);

% ---- Optimization objective  ----------
opti.minimize(T); % minimizing time

% ---- initial guesses for solver ---
%opti.set_initial(X, repmat(Y0-Y1,[1 Nt+1]));
opti.set_initial(U, -C/2);
opti.set_initial(T, FinalTime);

% ---- solve NLP              ------
opti.solver('ipopt'); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc
%% Post-processing
Sol_t = sol.value(T); % opti.debug.value(T) if it stops at an infeasible point.
tline = linspace(0,Sol_t,Nt+1);
Sol_x = zeros(Nx+2,Nt+1); % solved variable
Sol_x(2:end-1,:) = sol.value(X);
Sol_u = zeros(Nx+2,Nt); 
Sol_u(2:end-1,:) = PB*(sol.value(U) + C); % solved control + C

xxline = zeros(Nx+2,1); % Space discretization including $-1$ and $1$
xxline(2:end-1) = xline;
xxline(1) = 2*xline(1)-xline(2); 
xxline(end) = 2*xline(end)-xline(end-1);
xxline = repmat(xxline,[1 Nt+1]);
ttline = repmat(tline,[Nx+2 1]);

Y = zeros(Nx,Nt+1); % Target trajectory
for k=1:Nt % loop over control intervals
   % Euler forward method
   Y(:,k+1) = Y(:,k) + (Sol_t/Nt)*f(Y(:,k),C*ones(Nx_u,1)); 
end
Sol_y = zeros(Nx+2,Nt+1);
Sol_y(2:end-1,:) = Y;

Sol_z = Sol_x + Sol_y; % controled trajectory

figure
% hold on
surf(xxline,ttline,Sol_z);
xlabel('Position'); ylabel('Time'); zlabel('Value');

figure
surf(xxline(:,1:end-1),ttline(:,1:end-1),Sol_u);
xlabel('Position'); ylabel('Time'); zlabel('Control');

figure
hold on
plot(xxline,Sol_x(:,end));
%plot(xxline,Sol_y(:,end));
