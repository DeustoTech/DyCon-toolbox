%% title: Average Control by Stochastic Gradiente
%% date: 2018-07-21
%% author: [VictorH, JoseV, EnriqueZ]

%%
% In this work, we address the optimal control of parameter-dependent systems. 
% We introduce the notion of averaged control in which the quantity of interest 
% is the average of the states with respect to the parameter family 
% $$\mathcal{K}= \left\{ \nu_i \in \mathbb{R}, \enspace 1\leq i \leq K \right\}.$$
%%
% In this case $\nu_i$ are:
%
nu = 1:0.1:6
%%
% And save in K, the number of values  
K = length(nu);
%%
% Where the finite dimensional linear control system is:
%
% $$\begin{align*}  \left\{ \begin{array}{ll} x^\prime \left( t \right) = A 
% \left( \nu \right) x \left( t \right) + B \left( \nu \right) u \left( t \right),
% \quad 0 < t <T, \\ x\left( 0 \right) = x^0. \end{array} \right. \end{align*}$$
%
%%
% We can, define the initial state of all ode's
N = 5; % dimension of vector state
x0 = ones(N, 1);
%%
%Moreover, we can define the matrix A's and B's, that determine the problem
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
% Also, need define a initial control, that will be evolve 
dt = 0.02; t0 = 0; T  = 1;
span = (t0:dt:T);
%
u0 = zeros(length(span),1);
%% 
xt = [0 0 0.0 0 0]';

%%
AverageProblemSG = AverageControl.empty;
AverageProblemCG = AverageControl.empty;
index_nu = 0;

for dnu= 0.1:0.1:1
    index_nu = index_nu + 1;
    nu = 1:dnu:6;
    %%
    % And save in K, the number of values  
    K = length(nu);

    N = 5; % dimension of vector state
    x0 = ones(N, 1);
    %%
    %Moreover, we can define the matrix A's and B's, that determine the problem
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
    AverageProblemSG(index_nu) = AverageControl(A,B,x0,u0,span);
    AverageProblemCG(index_nu) = AverageControl(A,B,x0,u0,span);
    
    
    solveStochasticGradient(AverageProblemSG(index_nu),xt)
    solveClassicalGradient(AverageProblemCG(index_nu),xt)

end

addta = [AverageProblemSG.addata];
time_executions =  [addta.time_execution];


% AverageProblemCG = AverageControl(A,B,x0,u0,span);
% plot(AverageProblemCG)
% 
% AverageProblemSG = copy(AverageProblemCG);
% solveStochasticGradient(AverageProblemSG,xt)
% plot(AverageProblemSG)
% 
%animation(AverageProblem,'dt',0.1,'ULim',[-10 20],'XLim',[-2 2])
%%



%% References 
% [^fn]:  E. Zuazua (2014) Averaged Control. Automatica, 50 (12), p. 3077-3087.






