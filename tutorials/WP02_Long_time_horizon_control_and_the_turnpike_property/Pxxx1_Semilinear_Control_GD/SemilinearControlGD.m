%% title: Dario Gradient Descent in semilinear control
%% subtitle: Numerical computation of the optimal control
%% date: 2018-10-18
%% author: [DarioP , EnriqueZ ]

%%
% We solve
%%
% $$
% \min_{u\in L^2((0,T)\times (0,\frac12))}J_{T}(u)=\frac12 \int_0^T\int_{0}^{0.5} |u(t)|^2 dxdt+\frac{1}{2}\int_0^T\int_{0}^{1} |y(t,x)-z(x)|^2 dxdt,
% $$
%%
% where:
%%
% $$
% \begin{cases}
% y_t- y_{xx}+y^3=u\chi_{(0,\frac12)}\hspace{2.8 cm} & \mbox{in} \hspace{0.10 cm}(0,T)\times (0,1)\\
%
% y(t,0)=y(t,1)=0  & \mbox{on}\hspace{0.10 cm} (0,T)\\
%
% y(0,x)=y_0(x)  & \mbox{in}\hspace{0.10 cm}  (0,1).
% \end{cases}
% $$
%%
% For time horizon $T$ large, one can check the emergence of the Turnpike property (see [1]). For further details about the problem, see e.g. [1], [2] or [3].

%%
% We employ a Gradient Descent Method.

%% STEP 1. We define the parameters for the algorithm.

% Number of points in the space partition.
%We count the boundary 
Nx=50;

% Number of time steps
Nt=200;

%WARNING: We have to fulfill
%Courant-Friedrichs-Levy condition:
%2(\Delta t)\leq (\Delta x)^2.

%Time horizon
T=2;

%Penalization parameter for the state.
beta=1000;

%Initial datum for the state equation.
init=zeros(Nx,1);

%Target for the state.
zdiscr=ones(Nx,1);

% Maximum number of iterations
Nmax = 100;

% Stepsize for the Gradient Descent algorithm.
% appearing in the definition of the new iterate
% u = uold - delta*dJuold.
delta = 0.1;

% Tolerance
tol = 1e-1;
%% STEP 2. We initialize the algorithm.

% Control at time iter
u = zeros(Nt,floor(Nx/2));
% Control at time iter-1
uold = u;

%We compute the state yold corresponding to the control uold
    
%The multiplication by
%the characteristic function \chi_{(0,0.5)}
%is included
%in the definition of "source".
source=zeros(Nt,Nx);
for k=1:Nt
    for i=1:floor(Nx/2)
        source(k,i)=u(k,i);
    end
end

[ y ] = heat_semilinear( @(x) x.^3, T, init, source );

%We compute the adjoint state
%corresponding to control uiter.

%We define the matrix defining
%the discretized version of
%the source:
%\beta(y(t,x)-z(x)).

source=zeros(Nt,Nx);
for k=1:Nt
    for i=1:Nx
        source(k,i)=beta*(y(k,i)-zdiscr(i,1));
    end
end

[ p ] = adjoint_heat_semilinear( y, T, source );

prestr=p(:,1:floor(Nx/2));
prestrold=prestr;

% Initial error
error = 10;
% Iteration counter
iter = 0;

%% STEP 3. We set up a while loop for the Gradient Descent method.
while (error > tol && iter < Nmax)
    % Update iteration counter
    iter = iter + 1;
    
    % Gradient computed at u_{old}
    dJuold = uold+prestrold;
    % Update control
    u = uold - delta*dJuold;
    
    %We compute the state y_{iter} corresponding to the control uiter
    
    %In the definition of "source"
    %it is included the multiplication by
    %the characteristic function \chi_{(0,0.5)}.
    source=zeros(Nt,Nx);
    for k=1:Nt
        for i=1:floor(Nx/2)
            source(k,i)=u(k,i);
        end
    end
    
    [ y ] = heat_semilinear( @(x) x.^3, T, init, source );
    
    %We compute the adjoint state
    %corresponding to control uiter.
    
    %We define the matrix defining
    %the discretized version of
    %the source:
    %\beta(y(t,x)-z(x)).
    
    source=zeros(Nt,Nx);
    for k=1:Nt
        for i=1:Nx
            source(k,i)=beta*(y(k,i)-zdiscr(i,1));
        end
    end
    
    [ p ] = adjoint_heat_semilinear( y, T, source );
    
    prestr=p(:,1:floor(Nx/2));
    prestrold=prestr;
    
    %old control
    uold=u;
    
    % Control update norm
    dJuold2 = sum(sum(dJuold.^2))*(T/(Nt-1))*(1/(Nx-1));
    u2 = sum(sum(u.^2))*(T/(Nt-1))*(1/(Nx-1));
    
    if (u2 == 0)
        error=sqrt(dJuold2);
    else
        error=sqrt(dJuold2/u2);
    end
    
    %we compute the state term of the fucntional.
    stateterm=0;
    for k=1:Nt
        stateterm=stateterm+sum((transpose(y(k,:))-zdiscr).^2)*(1/(Nx-1))*(T/(Nt-1));
    end
    Ju=(0.5)*u2+(beta/2)*stateterm;
    
    fprintf("Iteration %i - Error %g - Cost %g\n", iter, error, Ju);
    
end
%% STEP 4. Optimal control and optimal state.

%approximate optimal control.
uopt=u;
%approximate optimal state.
yopt=y;

%% STEP 5. We plot optimal control and optimal state.

%% 
% Optimal control.
figure(1)
clf(1);
timecontrol=linspace(0,T,Nt);
spacecontrol=linspace(0,1,floor(Nx/2));
[TIMECONTROL,SPACECONTROL]=meshgrid(timecontrol,spacecontrol);
surf(TIMECONTROL,SPACECONTROL,transpose(uopt),'EdgeColor','none');
colormap jet;
%title('optimal control');
xlabel('t [time]','FontSize',20);
ylabel('x [space]','FontSize',20);
zlabel('u [control]','FontSize',20);
xt=get(gca,'XTick');
set(gca,'FontSize',20);
%%
% Optimal state.
figure(2);
clf(2);
time=linspace(0,T,Nt);
space=linspace(0,1,Nx);
[TIME,SPACE]=meshgrid(time,space);
surf(TIME,SPACE,transpose(yopt),'EdgeColor','none');
colormap jet;
%title('optimal state');
xlabel('t [time]','FontSize',20);
ylabel('x [space]','FontSize',20);
zlabel('y [state]','FontSize',20);
xt=get(gca,'XTick');
set(gca,'FontSize',20);

%% References
% [1]: Porretta, Alessio and Zuazua, Enrique, Remarks on long time versus steady state optimal control, Mathematical Paradigms of Climate Science, Springer, 2016, pp. 67--89.
%
% [2]: Casas, Eduardo and Mateos, Mariano, Optimal control of partial differential equations,
%    Computational mathematics, numerical analysis and applications,
%    Springer, Cham, 2017, pp. 3--5.
%
% [3]: Tr{\"o}ltzsch, Fredi, Optimal control of partial differential equations, Graduate studies in mathematics, American Mathematical Society, 2010.
