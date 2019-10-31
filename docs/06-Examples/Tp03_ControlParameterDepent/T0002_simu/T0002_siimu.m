
% In this case $\nu_i$ are
nu = linspace(1,6,10);
nu = 1;
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
iode.FinalTime = 1;
Y0 = ones(N, 1);
iode.InitialCondition = repmat(Y0,M,1);
iode.Nt = 400;

%% 
Ys = iode.StateVector.Symbolic;
U  = iode.Control.Symbolic;
%%
YT = zeros(N, 1); 
YT = repmat(YT,M,1);
Psi = @(T,Ys) (Ys - YT).'*(Ys - YT);
beta = 1e-7;
L   = @(t,Y,U) beta*(U.'*U);
%%
% Create the optimal control 
iCP1 = Pontryagin(iode,Psi,L);
%% 
% Solve 
U0 = zeros(iCP1.Dynamics.Nt,iCP1.Dynamics.ControlDimension);
%GradientMethod(iCP1,U0,'DescentAlgorithm',@ClassicalDescent,'DescentParameters',{'FixedLengthStep',true,'LengthStep',8e-2},'MaxIter',10000,'tol',1e-15,'display','all')
GradientMethod(iCP1,U0,'DescentAlgorithm',@ConjugateDescent)
%%
% See average free
solve(iode);
Yfree    = iode.StateVector.Numeric;
Ycontrol = iCP1.Dynamics.StateVector.Numeric;
%%

clf
subplot(1,2,1);
plot(Yfree)
ylim([-0.2 1])
subplot(1,2,2);

plot(Ycontrol)
ylim([-0.2 1])
