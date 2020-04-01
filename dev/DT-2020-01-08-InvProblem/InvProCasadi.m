% The initialization parameters look as follows:
N=20; % space discretization points in y-direction
dx=1/(N+1); % mesh size
t0=0; % initial time
tf=0.1; % final time
n=5; % time discretization points
dt=(tf-t0)/n; % stepsize
TOL=1e-5; % stopping tolerance

d1=0.05; % diffusivity of the material on the left sudomain
d2=0.05; % diffusivity of the material on the left sudomain

% advection components
vx=0;
vy=-3;

tau=dx^4; % regularization parameter
epsilon=0.1; % stepsize of the gradient descent method
%%
% We now compute the FE discretization matrices $M$, $A$ and $V$ that are
% respectively the mass matrix, the stiffness matrix and the advection
% matrix. For the FE discretization we assume equidistant structured
% meshes. In particular we use triangular elements and the classical pyramidal test
% functions are employed. 
%%
[M,A,V] = computeFEmatrices(N,d1,d2,vx,vy); % Compute FE discretization matrices
%%
% A reference initial condition is chosen and we compute using the FE
% discretization specified above and implicit Euler in time its
% corresponding final state at time $T$. This final state will be considered the
% initial data of the inverse problem to be solved and we name it the target function $u^*$ as mentioned previously. 
%%
U0_ref = initial_deltas(N); % computes reference initial condition

[U_target,u_target] = compute_target(U0_ref,N,n,dt,M,A,V); % Compute target distribution
%%
opti = casadi.Opti();  %% CasADi function

Ucas = opti.variable(length(u_target),n); %% state trajectory

%opti.subject_to(Ucas(:,1) == U0_ref(:))

opti.subject_to(Ucas(:,end) == u_target)
%% ---- Dynamic constraints --------
for k=2:n %% loop over control intervals
   %% Crank-Nicolson method : this helps us to boost the optimization
   opti.subject_to(Ucas(:,k)== (M+dt*A+dt*V)\(M*Ucas(:,k-1)))
end

opti.subject_to(Ucas(:) >= 0)

opti.minimize(sum(Ucas(:,1))) ; % minimizing L2 at the final time
opti.solver('ipopt'); % set numerical backend
sol = opti.solve();   % actual solve

%%

Ut = sol.value(Ucas);

U0 = zeros(N+2,2*N+3);
U0(2:end-1,2:end-1) = reshape(Ut(:,end),N,2*N+1);
%%
figure
for it = 1:n
   surf(reshape(Ut(:,it),N,2*N+1))
   pause(0.5)
end