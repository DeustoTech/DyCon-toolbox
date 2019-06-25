
    %% Dynamics 
    p.T  = 0.2;
    %%
    p.Nx = 10;
    p.Nt = 10; p.dt = p.T/(p.Nt-1);
    %%
    p.xline = linspace(-1,1,p.Nx);
    p.tline = linspace( 0,p.T,p.Nt);
    %%
    
    p.A = -FEFractionalLaplacian(0.8,1,p.Nx);
    %p.A =  FDLaplacian(p.xline);
    p.B =  BInterior(p.xline,-0.3,0.8);
    % problem parameters
    %
    p.y0 = 0.5*cos(0.5*pi*p.xline');
    %% Target
    p.M = massmatrix(p.xline);
    p.dynamics.MassMatrix = p.M;
    p.InverseM =  (p.M)^-1;

    p.dynamics = pde('A',p.A,'B',p.B);
    p.dynamics.mesh = p.xline;
    p.dynamics.Solver = @eulere;

    p.dynamics.FinalTime = p.T;
    p.dynamics.Nt = p.Nt;
    
    p.dynamics.InitialCondition = 6*cos(0.5*p.xline);
    U0 = zeros(p.Nt-1,p.Nx) + 1;
    [~ , ytarget ] = solve(p.dynamics,'Control',U0);
    
    p.yf =  ytarget(end,:)';
    %%
    xsym = sym('x',[1+2*p.Nt*p.Nx 1]);
    contraintsSym = constraints(xsym,p);
    %%
    dcontraintsSym = jacobian(contraintsSym,xsym);
    dcontraintsNum = matlabFunction(dcontraintsSym,'Vars',xsym);
    
    %%
    x0 = 0 + zeros(1+2*p.Nt*p.Nx,1); % initial guess (all zeros)
    x0(end) = 0.5;
    options = optimoptions(@fmincon,'display','iter','MaxFunctionEvaluations',1e5,'UseParallel',true); % options
    % solve the problem
    [x ,J] = fmincon(@(x) objective(x,p),x0,[],[],[],[],[],[],@(x) constraints(x,p),options);
    %x = fmincon(@(x) objective(x,p),x0,[],[],[],[],[],[],[],options);
    % obtain the optimal solution
    yopt = x(1:p.Nx*p.Nt); % extract
    yopt = reshape(yopt,p.Nt,p.Nx);
        
    uopt = x(1+p.Nx*p.Nt:end-1); % extract
    uopt = reshape(uopt,p.Nt,p.Nx);
    
    p.solution.yopt = yopt;
    p.solution.uopt = uopt;
    
    p.solution.Jopt = J;
    %%
    % objective function
    function [f,df] = objective(x,p)
        f = p.Nt*x(end);
        df = zeros(1+2*p.Nt*p.Nx);
        df(end) = 1;
    end
    % constraint function
    function [c,ceq] = constraints(x,p)
        
        
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nt,p.Nx);
        
        u = x(1+p.Nx*p.Nt:end-1); % extract
        c = -u;
        u = reshape(u,p.Nt,p.Nx);
        
        F = p.InverseM*(p.A*y' + p.B*u');
        F = F';
        % initial state conditions
        ceqInit =  y(1  ,:)'  - p.y0; 
        % final state conditions
        ceqFinal = y(end,:)'  - p.yf; 
        % defect constraints
        ceqDyn  = zeros(p.Nx,p.Nt -1,class(x));
        
        dt = x(end)/p.Nt;
        for i = 1:p.Nx
            ceqDyn(i,:) = (y(2:p.Nt,i) - y(1:p.Nt-1,i) - dt/2.*( F(1:p.Nt-1,i) + F(2:p.Nt,i) ));
        end
        ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
        
        ctime = x(end);
        
        ceq = [ceqInit;ceqFinal;ceqDyn';ctime]; % combine constraints
    end

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
