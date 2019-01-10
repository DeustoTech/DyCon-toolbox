%%
% In the previous [work]({{site.url}}{{site.baseurl}}/tutorial/tp03/T0002), the concept of averaged control [^fn] of 
% parameter-dependent systems is introduced. The optimal control of the following 
% functional is obtained applying the classical gradient descent algorithm
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
% In this tutorial the main goal is to apply the stochastic gradient
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
nu = 1:0.1:5;
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
dt = 0.02;
t0 = 0; T  = 1;
span = (t0:dt:T);
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
AverageStochasticGradient(AverageProblemSG,xt)
plot(AverageProblemSG)
%%
% Notice that, it is know that the SGD converges in mean [^fn1].
% Hence, with only one trail of the stochastic algorithm it is possible do not have 
% convergence. To see the convergence it is necessary to run the iterative 
% method different times and to do the mean of all the trayectories
%%
% We define the number of trails of the stochastic method, as well as the
% maximum number of iterations, the tolerance and other auxiliar quantities.
trails = 50;
MaxIter = 50;
Tol = 1e-4;
%%
AverageProblemSG = ControlParameterDependent.empty;
J_executionsSG = {};
error_executionsSG = {};
index_trail = 0;
%%
% Now, the main problem is solved for each trail 
while index_trail < trails
    
    index_trail = index_trail + 1;
    % Save the object in array 
    AverageProblemSG(index_trail) = ControlParameterDependent(A,B,x0,u0,span);
    AverageStochasticGradient(AverageProblemSG(index_trail),xt,'MaxIter',MaxIter,'tol',Tol)
    addtaSG = [AverageProblemSG(index_trail).addata];
    
    J = addtaSG.Jhistory;
    J_executionsSG{index_trail} = J;
    
    error = addtaSG.error_history;
    error_executionsSG{index_trail} = error;
end
%%
% Here, we plot the trails and the mean of all trayectories  
figure
for i=1:trails
    plot( J_executionsSG{i},'color',[0.4,0.8,0.9])
    hold on 
end
title('Cost Function','interpreter','latex')
xlabel('Epoch','interpreter','latex')
plot(mean_null(J_executionsSG),'r','LineWidth',1.75)
%%
figure
for i=1:trails
    plot( error_executionsSG{i},'color',[0.4,0.8,0.9])
    hold on 
end
title('Error','interpreter','latex')
xlabel('Epoch','interpreter','latex')
plot(mean_null(error_executionsSG),'r','LineWidth',1.75)
%%
% We can observe the convergence of the trayectories
%% References 
% [^fn]:  E. Zuazua (2014), Averaged Control. Automatica, 50 (12), p. 3077-3087.
%%
% [^fn1]: F. Bach and E. Moulines (2011), Non-asymptotic analysis of stochastic approximation algorithms for machine learning, Advances in Neural Information Processing Systems.
