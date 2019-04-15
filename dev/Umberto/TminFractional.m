% Definition of the time 
Nx = 50;
xi = -1; xf = 1;
xline = linspace(xi,xf,Nx+2);
xline = xline(2:end-1);
dx = xline(2)-xline(1);
    
%%
s = 0.8;
A = -FEFractionalLaplacian(s,1,Nx);
M = massmatrix(xline);
%%
% Moreover, we build the matrix $B$ defining the action of the control, by
% using the program "BInterior" (see below).
a = -0.3; b = 0.8;
B = BInterior(xline,a,b);

%%
% we define symbolically the vectors of the state and the control
%%
symY = SymsVector('y',Nx);
symU = SymsVector('u',Nx+1);

Fsym  =(A*symY + B*symU(1:end-1)) /symU(end);

%% Initial condition
Y0 = 0.5*cos(0.5*pi*xline');
Nt = 100;
FinalTime = 1;
dt = FinalTime/Nt;
%dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics = pde(Fsym,symY,symU,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
dynamics.MassMatrix = M;
dynamics.mesh = xline;
dynamics.Solver = @ode23tb;
%% Calculate the Target
Y0_other = 3*cos(0.5*pi*xline');
TargetDynamics = copy(dynamics);
TargetDynamics.InitialCondition = Y0_other;
U00 = TargetDynamics.Control.Numeric*0 + 5;
U00(end,:) = 0.01;

%U00 = cos(3*pi*xline')*cos(20*pi*dynamics.tspan);
[~ ,YT] = solve(TargetDynamics,'Control',U00);

YT =YT(end,:).';
    %YT = 0*xline' + 1;
    %YT = 0*xline' + 5;
%%
% We create the functional that we want to minimize
% Our goal is to set the system to zero penalizing the norm of the control
% by a parameter $\beta$ that will be small.
symPsi  = dx*(YT - symY).'*(YT - symY);
beta=0.1;
symL = beta*(1/symU(end));

    %OCParmaters{:}%%
    % build problem with constraints
    %iOCP =  Pontryagin(dynamics,Psi,L,OCParmaters{:});
    iOCP =  Pontryagin(dynamics,symPsi,symL);
    iOCP.Target = YT;
    iOCP.constraints.Projector = @(U) [U(:,1:end-1), repmat(trapz(dynamics.tspan,abs(U(:,end))),Nt+1,1)];

    %iOCP.constraints.Umax =  50;
    %iOCP.constraints.Umin =  0;

    %%
    U0 = zeros(iOCP.dynamics.Udim,Nt+1)';
    U0(end,:) = 0.001;
    % Solver L1
    Parameters = {'DescentAlgorithm',@AdaptativeDescent, ...
                 'tol',1e-9,                                    ...
                 'Graphs',true,                               ...
                 'MaxIter',5000,                               ...
                 'U0',U0,                                       ...
                 'display','all',};
    %%
    GradientMethod(iOCP,Parameters{:})
    
    
    tline_UO = dt*cumtrapz(iOCP.dynamics.Control.Numeric(:,end)); % timeline based on the values of t, which is the integration of T(s)ds.
plot(tline_UO,iOCP.dynamics.Control.Numeric(:,end-1),'LineWidth',1.3)
%%
% We create the ODE object
% Our ODE object will have the semi-discretization of the semilinear heat equation.
% We set also initial conditions, define the non linearity and the interaction of the control to the dynamics.
%%
function M = massmatrix(mesh)
    N = length(mesh);
    dx = mesh(2)-mesh(1);
    M = 2/3*eye(N);
    for i=2:N-1
        M(i,i+1)=1/6;
        M(i,i-1)=1/6;
    end
    M(1,2)=1/6;
    M(N,N-1)=1/6;
            
    M=dx*sparse(M);
end