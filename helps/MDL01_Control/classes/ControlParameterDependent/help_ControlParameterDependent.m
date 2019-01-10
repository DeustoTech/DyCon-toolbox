%%
% The optimal control of the following 
% functional is obtained applying the classical gradient descent algorithm
%%
% $$ \begin{equation*}  
% \min_{u \in L^2(0,T)} \mathcal{J}\left( u\right) = 
% \min_{u \in L^2(0,T)} \frac{1}{2} \left[ \frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} x \left( T, \nu \right) - \bar{x} \right]^2  + 
% \frac{\beta}{2} \int_0^T u^2 \mathrm{d}t, \quad \beta \in \mathbb{R}^+ 
% \end{equation*} $$ 
%%
% Subject to the finite dimensional linear control system mentioned before, the goal is to apply the stochastic gradient
% descent method to obtain the minimun of the same optimal control problem.
%%
% In this case, the iterative method is defined as 
%%
% $$\begin{equation*} 
% u^{\left( k+1 \right)} = u^{\left( k \right)} - \gamma \left( \beta
% u^{\left( k \right)}- B^{\top}p \left( t,\nu_{i_k} \right) \right),
% \end{equation*} $$
%%
% where $p \left( t,\nu_{i_k} \right)$ is solution of the following adjoint
% problem
%%
% $$ \begin{align*} \left\{ \begin{array}{ll} p^\prime \left( t, \nu \right) = 
% -A \left( \nu \right) p \left( t,\nu \right), \quad 0 < t <T, \\ \displaystyle p\left( T \right) = 
% - \left[ \frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} x \left( T, \nu \right) - \bar{x} \right]. \end{array} \right. \end{align*} $$
%
%%
% The values of parameter $\nu_i$ are
nu = 1:1:5;
%%
% And save in K, the number of values  
K = length(nu);
    %%
% We can, define the initial state of all ODE's
N = 2; % dimension of vector state
x0 = ones(N, 1);
%% 
% We take as final target
xt = [0.5;0]; 
%%
% Also, we need to define a initial control, that will be evolve 
dt = 0.02; t0 = 0; T  = 1; span = (t0:dt:T);
%
u0 = zeros(length(span),1);
%%
% Moreover, we can define the matrix A's and B's, that determine the
% linear system
Am = -triu(ones(N));
%%
Bm = zeros(N, 1);
Bm(N) = 1;
%%
A = zeros(N,N,K);
B = zeros(N,1,K);
for index = 1:K
    A(:,:,index) = Am + (nu(index) - 1 )*diag(diag(Am));
    B(:,:,index) = Bm;
end
%%
% Then, we solve the problem applying the stochastic gradient descent
% algorithm
AverageProblemSG = ControlParameterDependent(A,B,x0,u0,span);
%%
AverageStochasticGradient(AverageProblemSG,xt)
%%
% You can see the results
plot(AverageProblemSG)
