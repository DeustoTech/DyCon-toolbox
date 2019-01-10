
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
%
nu = 1:3:6
%%
% And save in K, the number of values  
K = length(nu);
%%
% We can, define the initial state of all ODE's
N = 3; % dimension of vector state
Y0 = ones(N, 1);
%%
% Also, need define a initial control, that will be evolve 
dt = 0.02; T  = 1;

%%
% Moreover, we can define the matrix A's and B's, that determine the problem
Am = -triu(ones(N))
%%
Bm = zeros(N, 1);
Bm(N) = 1
%%
% So, we can create these edo's in variable primal_odes.
parmsODE = {'dt',dt,'T',T};
ParameticODE = LinearODE.empty;
for index = 1:K
    A = Am + (nu(index) - 1 )*diag(diag(Am));
    %
    ParameticODE(index) = LinearODE(A,Bm,parmsODE{:});
    % time intervals
    % initial state
    ParameticODE(index).Y0 = Y0;
end
%%
% So, we have a $K$ ordinary differential equations 
ParameticODE
%%
span = ParameticODE(1).tline;
%% 
% We take as final target
YT = zeros(N, 1);
%%
% We can use the classical gradient descent method based on the adjoint methodology to obtain the iterative method
% in order to compute the optimal control. Applying this methodology we obtain the corresponding adjoint system for [^fn],
%
% $$ \begin{align*} \left\{ \begin{array}{ll} p^\prime \left( t, \nu \right) = 
% -A \left( \nu \right) p \left( t,\nu \right), \quad 0 < t <T, \\ \displaystyle p\left( T \right) = 
% - \left[ \frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} x \left( T, \nu \right) - \bar{x} \right]. \end{array} \right. \end{align*} $$
%%
% The same way that before, we define the adjoints problems 
AdjointODEs =  LinearODE.empty;
for index = 1:K
    A = ParameticODE(index).A';
    B = ones(size(A));
    AdjointODEs(index) = LinearODE(A,B,parmsODE{:});
end
%%
% However the initial state  `adjoint_odes(index).x0` has not been assign. This initial state will be assign in every step of solution. 
%%
% To minimize the functional, $\mathcal{J}\left( u\right)$, we take the steepest descent direction given by
%%
% $$\begin{equation*} 
% u^{\left( k+1 \right)} = u^{\left( k \right)} - \gamma \left( \beta u^{\left( k \right)}-\frac{1}{|\mathcal{K}|} \sum_{\nu \in \mathcal{K}} B^{\top}p \left( t,\nu \right) \right) 
% \end{equation*} $$
%%
% We process to solve the problem of classical gradient descent
gamma = 1;
beta  = 1e-3;
tol   = 1e-8;  % Tolerance
error = Inf;
MaxIter = 100;
iter = 0;
xhistory = {}; uhistory = {};  error_history = [];    % array here we will save the evolution of average vector states
while (error > tol && iter < MaxIter)
    iter = iter + 1;
    % solve primal problem
    % ====================
    solve(ParameticODE);
    % calculate mean state final vector of primal problems  
    YMend = forall({ParameticODE.Yend},'mean');
    
    % solve adjoints problems
    % =======================
    % update new initial state of all adjoint problems
    for iode = AdjointODEs
        iode.Y0 = -(YMend' - YT);
    end
    % solve adjoints problems with the new initial state
    solve(AdjointODEs);
    
    % update control
    % ===============
    % calculate mean state vector of adjoints problems  
    pM = forall({AdjointODEs.Y},'mean');
    pM = pM*Bm;
    
    % reverse adjoint variable
    pM = flipud(pM);    
    % Control update
    U = ParameticODE(1).U; % catch control currently
    DU = beta*U - pM;
    U = U - gamma*DU;
    % update control in primal problems 
    for index = 1:K
        ParameticODE(index).U = U;
    end
    % Control error
    % =============
    % Calculate area ratio  of Du^2 and u^2
    Au2   =  trapz(span,U.^2);
    ADu2  =  trapz(span,DU.^2);
    %
    
    error = sqrt(ADu2/Au2);
    % Save evolution
    xhistory{iter} = [ span',forall({ParameticODE.Y},'mean')];
    uhistory{iter} = [ span',U]; 
    error_history  = [ error_history, error];
end
%% 
% The average control obtain is 
plot(span,U)
xlabel('time');ylabel('u(t)')
format_plot(gcf)
%%
% Also, on average the objective [0 0 0] has been reached.
figure;
plot(iode.tline,forall({ParameticODE.Y},'mean'))
xlabel('t');ylabel('x_{i}(t)')
legend(strcat('x_{',num2str((1:N)','%0.1d'),'}(t)'))
title('Evolution of cordinates of vector state.')
format_plot(gcf)
%% 
% We can see
% ![Evolution in each iteration](extra-data/average_control.gif)
%% 
% If we analyze the evolution in the error, we can see that we should have stopped, in iteration 20.
plot(error_history,'-*')
title('Error Evolution')
ylabel('Error'); xlabel('Iterations')
format_plot(gcf)
%% References 
% [^fn]:  E. Zuazua (2014) Averaged Control. Automatica, 50 (12), p. 3077-3087.






