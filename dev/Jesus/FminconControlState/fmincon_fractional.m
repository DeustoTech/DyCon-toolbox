



p = Method_SingleStep_fun;

[p.xms ,p.tms] = meshgrid(p.xline,p.tline);

figure 
subplot(1,2,1)
surf(p.xms,p.tms,p.solution.yopt')
title('State')

subplot(1,2,2)
surf(p.solution.uopt')
title('Control')



p.dynamics.InitialCondition = p.y0;
p.free_dynamics = copy(p.dynamics);

p.free_dynamics.label = 'free';
p.dynamics.label = 'Control';

solve(p.dynamics,'Control',p.solution.uopt')
p.dynamics.StateVector.Numeric = p.solution.yopt';
%p.dynamics.Control.Numeric = p.solution.uopt'*p.B;
p.dynamics.Control.Numeric = p.solution.uopt';

solve(p.free_dynamics,'Control',0*p.solution.uopt')

%animation([p.dynamics, p.free_dynamics],'xx',0.005,'Target',p.yf,'YLim',[0,20],'YLimControl',[0 500])



function p = Method_SingleStep_fun
    %% Dynamics 
    p.T  = 0.2;
    %%
    p.Nx = 15;
    p.Nt = 60; p.dt = p.T/(p.Nt-1);
    %%
    p.xline = linspace(-1,1,p.Nx);
    p.dx =  p.xline(2) - p.xline(1);
    p.tline = linspace( 0,p.T,p.Nt);
    %%
    
    p.A = -FEFractionalLaplacian(0.8,1,p.Nx);
    
    a = -0.3;b = 0.5;
    newcontrol = (p.xline>=a).*(p.xline<=b);
    control = newcontrol;
    control(control == 0) = [];
    p.Nu = length(control);
    
    p.B =  BInterior(p.xline,-0.3,0.8);
    %p.Nu = p.Nx;
    p.B =  p.B(:,newcontrol == 1);
    % problem parameters
    %
    p.y0 = 0.5*cos(0.5*pi*p.xline');
    %% Target
    p.M = massmatrix(p.xline);
    p.M = diag(ones(1,length(p.xline)));
    p.dynamics.MassMatrix = p.M;
    p.InverseM =  (p.M)^-1;

    p.dynamics = pde('A',p.A,'B',p.B);
    p.dynamics.mesh = p.xline;
    p.dynamics.Solver = @eulere;

    p.dynamics.FinalTime = p.T;
    p.dynamics.Nt = p.Nt;
    
    p.dynamics.InitialCondition = 6*cos(0.5*p.xline');
    U0 = zeros(p.Nt,p.Nu) + 1;
    [~ , ytarget ] = solve(p.dynamics,'Control',U0);
    
    p.yf =  ytarget(end,:)';
    p.beta  = 0.01;
    %% Initial Guess.
    p.dynamics.InitialCondition = p.y0;
    uguess = U0*0; uguess(1:floor(p.Nt/5),:) = 100;
    %uguess = uguess*p.B;
    
    
    %%
    options = optimoptions(@fmincon,'display','iter', ...
                                    'Algorithm','interior-point', ...
                                    'MaxFunctionEvaluations',1e6, ...
                                    'CheckGradients',false, ...
                                    'SpecifyObjectiveGradient',true,        ...
                                    'SpecifyConstraintGradient',true,        ...
                                    'UseParallel',true); % options
    
    %%
    [x ,J] = fmincon(@(u) OBJFminconOC(u,p) ,uguess,             ...
                                         [],[],                  ...   % lineal ieq
                                         [],[],                  ...   % lineal eq
                                         zeros(1,p.Nu*p.Nt),     ...   % low boundaries
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
   
    % constraint function
    function [c,ceqDyn] = constraints(x,p)
        
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nx,p.Nt);
        
        u = x(1+p.Nx*p.Nt:end); % extract
        %c = -u;
        c = [];
        u = reshape(u,p.Nu,p.Nt);
        
        F = p.InverseM*(p.A*y + p.B*u);
        %F = F';
        % defect constraints
        ceqDyn  = zeros(p.Nx,p.Nt -1,'sym');
        for i = 1:p.Nx
            ceqDyn(i,:) = (y(i,2:p.Nt) - y(i,1:p.Nt-1) - p.dt/2.*( F(i,1:p.Nt-1) + F(i,2:p.Nt) ));
        end
        ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
                
    end


    function [c,ceqDyn] = preconstraints(x,p)
        
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nx,p.Nt);
        
        u = x(1+p.Nx*p.Nt:end); % extract
        %c = -u;
        c = [];
        u = reshape(u,p.Nu,p.Nt);
        
        F = p.InverseM*(p.A*y + p.B*u);
        %F = F';
        % defect constraints

        ceqDyn = (y(1,2:p.Nt) - y(1,1:p.Nt-1) - p.dt/2.*( F(1,1:p.Nt-1) + F(1,2:p.Nt) ));
        %ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
                
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
