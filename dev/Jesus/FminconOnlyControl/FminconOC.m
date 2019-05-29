
    %% Dynamics 
    clear
    %%
    Nx = 70;
    %%
    xline = linspace(-1,1,Nx);
    %%
    A = -FEFractionalLaplacian(0.8,1,Nx);
    B =  BInterior(xline,-0.3,0.8,'min');
    % problem parameters
    %
    dynamics            = pde('A',A,'B',B);
    dynamics.mesh       = xline;
    dynamics.FinalTime  = 0.2;
    dynamics.Nt         = 50; 
    dynamics.MassMatrix = massmatrix(xline);
    %
    dynamics.InitialCondition = 0.5*cos(0.5*pi*xline');
    %% Target
    TargetDynamics = copy(dynamics);
    TargetDynamics.InitialCondition = 6*cos(0.5*xline');
    U0 = zeros(dynamics.Nt,dynamics.Udim) + 1;

    [~ , ytarget ] = solve(TargetDynamics,'Control',U0);
    ytarget =  ytarget(end,:)';
    
    %% Initial Guess.
    uguess = U0*0; %uguess(1:floor(dynamics.Nt/5),:) = 100;
    %uguess = uguess*p.B;
    
    %% create structure
    p.dynamics = dynamics;
    p.ytarget  = ytarget;
    
    %% M 
    
    funM = @(M) reshape(A*reshape(M,Nx,Nx),Nx*Nx,1);
    M0 = eye(Nx,Nx);
    M0 = M0(:);
    
    [~ ,Msol] = ode45(@(t,M) funM(M),dynamics.tspan,M0);
    p.M = Msol;
    
    Msolfun = @(index) reshape((reshape(Msol(end,:),Nx,Nx))*((reshape(Msol(index,:),Nx,Nx))\B),Nx*dynamics.Udim,1);
    AllMsol = arrayfun(@(it) Msolfun(it),1:dynamics.Nt,'UniformOutput',0);
    AllMsol = [AllMsol{:}];
    
    AllMsol = reshape(AllMsol,p.,Nx);
    
    
    for iNx = 1:Nx 
        
    end
    %%

    p.M = AllMsol;
    %% Options fmincon
    options = optimoptions(@fmincon,'display','iter', ...
                                    'Algorithm','interior-point', ...
                                    'MaxFunctionEvaluations',1e6, ...
                                    'CheckGradients',true, ...
                                    'SpecifyObjectiveGradient',true,        ...
                                    'SpecifyConstraintGradient',true,        ...
                                    'UseParallel',false, ...
                                    'PlotFcn',{@(x,optimvalues,init) fmpoc11(p,x,optimvalues,init), ...
                                               @(x,optimvalues,init) fmpoc12(p,x,optimvalues,init), ...
                                               @(x,optimvalues,init) fmpoc21(p,x,optimvalues,init)}); % options

    
    %% fmincon run
    [x ,J] = fmincon(@(u) OBJFminconOC(u,p) ,uguess,             ...
                                         [],[],                  ...   % lineal ieq
                                         [],[],                  ...   % lineal eq
                                         -1e-8 + zeros(1,dynamics.Udim*dynamics.Nt),     ...   % low boundaries
                                         [],                     ...   % up boundaries
                                         @(u) CONFminconOC(u,p), ...   % nolineal constraints
                                         options);

         % obtain the optimal solution
    yopt = x(1:p.Nx*p.Nt); % extract
    yopt = reshape(yopt,p.Nx,p.Nt);
        
    uopt = x(1+p.Nx*p.Nt:end); % extract
    uopt = reshape(uopt,p.Nu,p.Nt);
    
    p.solution.yopt = yopt;
    p.solution.uopt = uopt;
    
    p.solution.Jopt = J;
    %%
    % objective function
  %%%

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
    


