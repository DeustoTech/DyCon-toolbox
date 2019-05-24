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
p.dynamics.Control.Numeric = p.solution.uopt'*p.B;

solve(p.free_dynamics,'Control',0*p.solution.uopt')

animation([p.dynamics, p.free_dynamics],'xx',0.005,'Target',p.yf,'YLim',[0,20],'YLimControl',[0 500])



function p = Method_SingleStep_fun
    %% Dynamics 
    p.T  = 0.2;
    %%
    p.Nx = 12;
    p.Nt = 30; p.dt = p.T/(p.Nt-1);
    %%
    p.xline = linspace(-1,1,p.Nx);
    p.dx =  p.xline(2) - p.xline(1);
    p.tline = linspace( 0,p.T,p.Nt);
    %%
    
    p.A = -FEFractionalLaplacian(0.8,1,p.Nx);
    %p.A =  FDLaplacian(p.xline);
    

    a = -0.3;b = 0.5;
    newcontrol = (p.xline>=a).*(p.xline<=b);
    control = newcontrol;
    control(control == 0) = [];
    p.Nu = length(control);
    
    p.B =  BInterior(p.xline,-0.3,0.8);
    p.Nu = p.Nx;
%     p.B =  p.B(:,newcontrol == 1)
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
    
    p.dynamics.InitialCondition = 6*cos(0.5*p.xline');
    U0 = zeros(p.Nt,p.Nu) + 1;
    [~ , ytarget ] = solve(p.dynamics,'Control',U0);
    
    p.yf =  ytarget(end,:)';
    %% Initial Guess.
    p.dynamics.InitialCondition = p.y0;
    uguess = U0*0;uguess(2:4,:) = 200;
    [~ , yguess ] = solve(p.dynamics,'Control',uguess);
    yguess = 0*reshape(yguess',p.Nt*p.Nx,1);
    uguess = 0*reshape(uguess',p.Nt*p.Nu,1);
    p.Umin = 0;
    
    tguess = 0.5;
    %x0 = zeros(p.Nt*(p.Nx + p.Nu),1); % initial guess (all zeros)
    %x0(1:p.Nt*p.Nx) = yguess;
    x0 = [yguess; uguess;tguess];
    %% Matrix constraint dynamics
    Cminus  = - p.M + 0.5*p.dt*p.A;
    Cplus   = + p.M + 0.5*p.dt*p.A;
    dtB05   =   0.5*p.dt*p.B; 
    diagonal = repmat({Cminus},1,p.Nt);
    diagonal = blkdiag(diagonal{:});
    
    dynamicsMatrix = blktridiag(0*Cminus,Cplus,Cminus,p.Nt);
    dynamicsMatrix((p.Nt-1)*p.Nx + 1:end) = 0;
    
    controlMatrix  = blktridiag(dtB05,dtB05,0*dtB05,p.Nt);
    fullmatrix = [dynamicsMatrix controlMatrix]
    
    fullb      = [Cplus*p.y0; zeros(p.Nx*(p.Nt-2),1);Cminus*p.yf]
    %%
    options = optimoptions(@fmincon,'display','iter', ...
                                    'Algorithm','interior-point', ...
                                    'MaxFunctionEvaluations',1e7, ...
                                    'CheckGradients',false, ...
                                    'SpecifyObjectiveGradient',true,        ...
                                    'UseParallel',true,             ...
                                    'PlotFcn',{@(x,optimvalues,init) fminconfractionalPlotFcnState(p,x,optimvalues,init)    ...
                                               @(x,optimvalues,init) fminconfractionalPlotFcnControl(p,x,optimvalues,init)  ...
                                               @(x,optimvalues,init) fminconfractionalPlotFcnInitial(p,x,optimvalues,init)  ...
                                               @(x,optimvalues,init) fminconfractionalPlotFcnFinal(p,x,optimvalues,init)  ...
                                               }); % options


    % solve the problem
    
    % Initial - Final Condition Matrix
    Aif = diag([ones(1,p.Nx), zeros(1,p.Nx*(p.Nt-2))  , ones(1,p.Nx)  , zeros(1,p.Nu*p.Nt + 1)]);
    bif =      [    p.y0'    , zeros(1,p.Nx*(p.Nt-2)) ,     p.yf'     , zeros(1,p.Nu*p.Nt+ 1)]';
    %
%     load('xseed')
%     x0 = x;
    [x ,J] = fmincon(@(x) objective(x,p),x0,                                          ...
                                         [],[],                                       ...   % lineal ieq
                                         Aif,bif,                                       ... % lineal eq
                                         [-Inf*ones(1,p.Nx*p.Nt),zeros(1,p.Nu*p.Nt + 1)], ...   % low boundaries
                                         [],                                          ...   % up boundaries
                                         @(x) constraints(x,p),                       ...   % nolineal constraints
                                         options);
    %x = fmincon(@(x) objective(x,p),x0,[],[],[],[],[],[],[],options);
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
    function varargout = objective(x,p)
        varargout{1} = x(end);
        %
        if nargout == 2 
        varargout{2} =  [zeros((p.Nx+p.Nu)*(p.Nt),1); ...
                        1];
        end
    end
    % constraint function
    function [c,ceqDyn] = constraints(x,p)
        
        y = x(1:p.Nx*p.Nt); % extract
        y = reshape(y,p.Nx,p.Nt);
        
        u = x(1+p.Nx*p.Nt:end-1); % extract
        %c = -u;
        c = [];
        u = reshape(u,p.Nu,p.Nt);
        
        F = p.InverseM*(p.A*y + p.B*u);
        %F = F';
        % defect constraints
        ceqDyn  = zeros(p.Nx,p.Nt -1);
        for i = 1:p.Nx
            ceqDyn(i,:) = (y(i,2:p.Nt) - y(i,1:p.Nt-1) - p.dt/2.*( F(i,1:p.Nt-1) + F(i,2:p.Nt) ));
        end
        ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
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
