
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
nu = 1:0.5:6;
%%
% Size of state vector
N = 4;
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
iode = ode('A',A,'B',B);
iode.FinalTime = 5;
Y0 = ones(N, 1);
iode.InitialCondition = repmat(Y0,M,1);
iode.Nt = 100;

%% 
Ys = iode.StateVector.Symbolic;
U  = iode.Control.Symbolic;
%%
Ysm = arrayfun(@(index) mean(Ys(index:(M+1):N*M)),1:N).';
Yt = ones(N, 1); 
Psi = (Ysm - Yt).'*(Ysm - Yt);
beta = 1e-5;
L   = 0.001*beta*(U.'*U);
%%
% Create the optimal control 
iCP1 = Pontryagin(iode,Psi,L);
%% 
% Solve 
U0 = ones(iCP1.Dynamics.Nt,iCP1.Dynamics.Udim);
GradientMethod(iCP1,U0,'DescentAlgorithm',@ConjugateDescent,'MaxIter',1000,'tol',1e-8)
%%
% See average free
solve(iode);
Yfree    = iode.StateVector.Numeric;
Ycontrol = iCP1.Dynamics.StateVector.Numeric;
%%
cellstate = arrayfun(@(index) mean(Yfree(:,index:(M+1):N*M),2),1:N,'UniformOutput',0);
meanvector = [cellstate{:}];
plot(meanvector);
legend(strcat(repmat('x_',N,1),num2str((1:N)')))
title('Free Average States')

%%
% Average Control
cellstate = arrayfun(@(index) mean(Ycontrol(:,index:(M+1):N*M),2),1:N,'UniformOutput',0);
meanvector = [cellstate{:}];
figure
plot(meanvector);
legend(strcat(repmat('x_',N,1),num2str((1:N)')))
title('Control Average States')
%% References 
% [^fn]:  E. Zuazua (2014) Averaged Control. Automatica, 50 (12), p. 3077-3087.



