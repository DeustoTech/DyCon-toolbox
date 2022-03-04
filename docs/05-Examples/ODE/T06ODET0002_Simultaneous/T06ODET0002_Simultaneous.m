import casadi.*
% In this case $\nu_i$ are
M = 50;
nu = linspace(1,6,M);
%%
% Size of state vector
[A,B] = GenMatSim(nu);

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
Nt = 500;T  = 0.8;
tspan = linspace(0,T,Nt);
% create linear dynamic
ts  = SX.sym('t'); % <= Create a symbolical time

iode = linearode(A,B,ts,tspan);
% set initial condition
Y0 = ones(2, 1);
iode.InitialCondition = repmat(Y0,M,1);

% Get Symbolical variable
Ys  = iode.State.sym;
Us  = iode.Control.sym;

% Set Target
YT = zeros(2, 1); 
YT = repmat(YT,M,1);

PathCost  =  (1/2)*(Us'*Us)      ;
FinalCost = 1e7*((Ys-YT).'*(Ys-YT));
%
% Create the optimal control 
iocp = ocp(iode,PathCost,FinalCost);
%% 
% Solve Optimal Control Problem
U0 = ZerosControl(iode);
[Uopt ,Yopt] =  IpoptSolver(iocp,U0);
%%
% Compute Free solution
Yfree = solve(iode,U0*0);
Yfree = full(Yfree);
%% plot 
fig = figure;
fig.Units = 'norm';fig.Position = [0.1 0.1 0.6 0.5];
%
plotSimu(tspan,Yfree,Yopt,Uopt,M)