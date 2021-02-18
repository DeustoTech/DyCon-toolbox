
%%
% In this work, we address the concept of optimal control of parameter-dependent systems. 
% We introduce the notion of averaged control in which the quantity of interest 
% is the average of the states with respect to the parameter family 
% $$\mathcal{K}= \left\{ \nu_i \in \mathbb{R}, \enspace 1\leq i \leq K \right\}.$$
%%
% Our objective it to solve the minimization problem
%%
% $$ \begin{equation*}  
% \min_{u \in L^2(0,T)} \mathcal{J}\left( u\right) = 
% \min_{u \in L^2(0,T)} \frac{1}{2} \left[ \frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} x \left( T, \nu \right) - \bar{x} \right]^2  + 
% \frac{\beta}{2} \int_0^T u^2 \mathrm{d}t, \quad \beta \in \mathbb{R}^+ 
% \end{equation*} $$ 
%%
% Subject to the finite dimensional linear control system
%%
% $$\begin{align*}  \left\{ \begin{array}{ll} x^\prime \left( t \right) = A 
% \left( \nu \right) x \left( t \right) + B \left( \nu \right) u \left( t \right),
% \quad 0 < t <T, \\ x\left( 0 \right) = x^0. \end{array} \right. \end{align*}$$
%%
% Then, a control $u\left( t \right)$ independent of the parameter $\nu$ will be performed in order to
% minimize the distance between the average of the final states and a given final target.
%%
% In this case $\nu_i$ are
clear
nu = 1:0.3:6;
%%
% Size of state vector
N = 2;
M = length(nu);
[A,B] = GenMatAve(nu,N,M);

%%
%%
% We can use the classical gradient descent method based on the adjoint methodology to obtain the iterative method
% in order to compute the optimal control. Applying this methodology we obtain the corresponding adjoint system for [^fn],
%
% $$ \begin{align*} \left\{ \begin{array}{ll} p^\prime \left( t, \nu \right) = 
% -A \left( \nu \right) p \left( t,\nu \right), \quad 0 < t <T, \\ \displaystyle p\left( T \right) = 
% - \left[ \frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} x \left( T, \nu \right) - \bar{x} \right]. \end{array} \right. \end{align*} $$
%%
% To minimize the functional, $\mathcal{J}\left( u\right)$, we take the steepest descent direction given by
%%
% $$\begin{equation*} 
% u^{\left( k+1 \right)} = u^{\left( k \right)} - \gamma \left( \beta u^{\left( k \right)}-\frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} B^{\top}p \left( t,\nu \right) \right) 
% \end{equation*} $$
%%
Nt = 100; T = 0.5;
tspan = linspace(0,T,Nt);
iode = linearode(A,B,tspan);
Y0 = ones(N, 1);
iode.InitialCondition = repmat(Y0,M,1);

%% 
Ys = iode.State.sym;
Us  = iode.Control.sym;
ts = casadi.SX.sym('ts');
%%
Ysm = arrayfun(@(index) mean(Ys(index:(M+1):N*M)),1:N,'UniformOutput',0);
Ysm = [Ysm{:}]';
Yt = zeros(N, 1); 
Psi =  1e8*(Ysm - Yt).'*(Ysm - Yt);
beta = 1e-5;
L   = (Us.'*Us);
%%
% Create the optimal control 
iocp = ocp(iode,L,Psi);
%% 
% Solve 
U0 = ZerosControl(iode);
[OptControl ,Ycontrol] = IpoptSolver(iocp,U0,'odeSolver','rk5');
%%
% See average free
[Yfree] = solve(iode,U0);
Yfree = full(Yfree);
%%
fig = figure(1);
fig.Units = 'norm';fig.Position = [0.1 0.1 0.6 0.6];
clf
plotAver(tspan,Yfree,Ycontrol,OptControl,M,N)

%%

%% References 
% [^fn]:  E. Zuazua (2014) Averaged Control. Automatica, 50 (12), p. 3077-3087.

