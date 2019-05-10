%--------------------------------------------------------------------------
% Method_SingleStep.m
% Attempt to solve the Bryson-Denham problem using a single-step method
% (namely the trapezodial rule with composite trapezoidal quadrature)
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% https://github.com/danielrherber/optimal-control-direct-method-examples
%--------------------------------------------------------------------------
clear all
p = Method_SingleStep_fun;

[p.xms ,p.tms] = meshgrid(p.xline,p.tline);

figure 
subplot(1,2,1)
surf(p.xms,p.tms,p.solution.yopt)
title('State')

subplot(1,2,2)
surf(p.xms,p.tms,p.solution.uopt*p.B)
title('Control')



p.dynamics.InitialCondition = p.y0;
p.free_dynamics = copy(p.dynamics);

p.free_dynamics.label = 'free';
p.dynamics.label = 'Control';

solve(p.dynamics,'Control',p.solution.uopt*p.B)
solve(p.free_dynamics,'Control',0*p.solution.uopt)

animation([p.dynamics, p.free_dynamics],'xx',0.05,'Target',p.yf,'YLim',[0,5],'YLimControl',[0 100])



function p = Method_SingleStep_fun
    %% Dynamics 
    p.T  = 0.2;
    %%
    p.Nx = 15;
    p.Nt = 50; p.dt = p.T/(p.Nt-1);
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
    p.dynamics.dt = p.T/(p.Nt-1);
    
    p.dynamics.InitialCondition = 6*cos(0.5*p.xline);
    U0 = zeros(p.Nt-1,p.Nx) + 1;
    [~ , ytarget ] = solve(p.dynamics,'Control',U0);
    
    p.yf =  ytarget(end,:)';
    %%
    
    x0 = 0 + zeros(1+2*p.Nt*p.Nx,1); % initial guess (all zeros)
    
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
    function f = objective(x,p)
        f = p.Nt*x(end);
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
        ceqDyn  = zeros(p.Nx,p.Nt -1);
        
        dt = x(end)/p.Nt;
        for i = 1:p.Nx
            ceqDyn(i,:) = (y(2:p.Nt,i) - y(1:p.Nt-1,i) - dt/2.*( F(1:p.Nt-1,i) + F(2:p.Nt,i) ));
        end
        ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
        
        ctime = -10*x(end);
        
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
end
