
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
    p.Nt = 30; p.dt = p.T/(p.Nt-1);
    %%
    p.xline = linspace(-1,1,p.Nx);
    p.dx =  p.xline(2) - p.xline(1);
    p.tline = linspace( 0,p.T,p.Nt);
    %%
    
    p.A = -FEFractionalLaplacian(0.8,1,p.Nx);
    p.A =  FDLaplacian(p.xline);
    
    a = -0.7;b = 0.5;
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
    p.dynamics.dt = p.T/(p.Nt-1);
    
    p.dynamics.InitialCondition = 6*cos(0.5*p.xline');
    U0 = zeros(p.Nt,p.Nu) + 1;
    [~ , ytarget ] = solve(p.dynamics,'Control',U0);
    
    p.yf =  ytarget(end,:)';
    %% Initial Guess.
    p.dynamics.InitialCondition = p.y0;
    uguess = U0*0; uguess(1:floor(p.Nt/5),:) = 100;
    %uguess = uguess*p.B;
    
    [~ , yguess ] = solve(p.dynamics,'Control',uguess);
    yguess = reshape(yguess',p.Nt*p.Nx,1);
    uguess = reshape(uguess',p.Nt*p.Nu,1);
    
    p.Umin = 0;
    
    x0 = [yguess; uguess];

    
    %%
    options = optimoptions(@fmincon,'display','iter', ...
                                    'Algorithm','interior-point', ...
                                    'MaxFunctionEvaluations',1e6, ...
                                    'CheckGradients',false, ...
                                    'SpecifyObjectiveGradient',true,        ...
                                    'SpecifyConstraintGradient',true,        ...
                                    'UseParallel',true); %,             ...
%                                     'PlotFcn',{@(x,optimvalues,init) fminconfractionalPlotFcnState(p,x,optimvalues,init)    ...
%                                                @(x,optimvalues,init) fminconfractionalPlotFcnControl(p,x,optimvalues,init)  ...
%                                                @(x,optimvalues,init) fminconfractionalPlotFcnInitial(p,x,optimvalues,init)  ...
%                                                @(x,optimvalues,init) fminconfractionalPlotFcnFinal(p,x,optimvalues,init)  ...
%                                                }); % options


    % solve the problem
    
    % Initial - Final Condition Matrix
    Aif = diag([ones(1,p.Nx), zeros(1,p.Nx*(p.Nt-2))  , ones(1,p.Nx)  , zeros(1,p.Nu*p.Nt)]);
    bif =      [    p.y0'    , zeros(1,p.Nx*(p.Nt-2)) ,     p.yf'     , zeros(1,p.Nu*p.Nt)]';
    %
    %load('xseed');
    %x0 = x;
    
    %%
    xx= sym('x',[1 p.Nt*(p.Nx + p.Nu)]).';
    
    
    funxx = objective(xx,p);
    funxxFcn = @(x) objective(x,p);
    %funxxFcn = matlabFunction(funxx,'Vars',{xx});
    dfunxx = gradient(funxx,xx);
    dfunxxFcn = matlabFunction(dfunxx,'Vars',{xx});
    
    [~,ceqDynxx] = constraints(xx,p);
    ceqDynxxFcn = @(x) constraints(x,p);
    %ceqDynxxFcn = matlabFunction(ceqDynxx,'Vars',{xx});
    %dceqDynxx = jacobian(ceqDynxx,xx);
    %[~ ,preceqDynxx] = preconstraints(xx,p);
    yjaco = jacobian(ceqDynxx(1:p.Nx),xx(1:2*p.Nx));
    %yjaco = yjaco(1:p.Nx,1:2*p.Nx);
    ujaco = jacobian(ceqDynxx(1:p.Nu),xx(p.Nx*p.Nt+1:p.Nx*p.Nt+p.Nu));
    %ujaco = jacobian(ceqDynxx,xx(p.Nx*p.Nt+1:end));

    %ujaco = ujaco(1:p.Nu,1:p.Nu);
    
    rowjaco = [yjaco,zeros(p.Nx,(p.Nt-2)*p.Nx,'sym'),ujaco,ujaco,zeros(p.Nx,(p.Nt-2)*p.Nu,'sym')];
    
    [nrow,ncol] = size(rowjaco);
    fulljaco = zeros(nrow*(p.Nt-1),ncol,'sym');
    for iter = 1:p.Nt-1
        fulljaco(1+(iter-1)*p.Nx:iter*p.Nx,1+(iter-1)*p.Nx:end) = rowjaco(:,1:end-(1+(iter-1)*p.Nx-1));
    end
    fulljaco = fulljaco';
    
    dceqDynxxFcn = matlabFunction(fulljaco,'Vars',{xx},'Sparse',true);
    
    
    %%
    [x ,J] = fmincon(@(x) numeric_objective(x,funxxFcn,dfunxxFcn) ,x0,                                          ...
                                         [],[],                                       ...   % lineal ieq
                                         Aif,bif,                                       ... % lineal eq
                                         zeros(1,2*p.Nu*p.Nt), ...  %[-Inf*ones(1,p.Nx*p.Nt),zeros(1,p.Nu*p.Nt)], ...   % low boundaries
                                         [],                                          ...   % up boundaries
                                         @(x) numeric_costraint(x,ceqDynxxFcn,dceqDynxxFcn),                       ...   % nolineal constraints
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
    
    function [J,dJ] = numeric_objective(x,fun,dfun)
        J = fun(x);
        dJ = dfun(x);
    end

    function [c,ceqDyn,dc,dceqDyn] = numeric_costraint(x,fun,dfun)
        dc=[];
        [c ,ceqDyn] = fun(x);
        %ceqDyn = fun(x); c = [];
        ceqDyn = double(ceqDyn);
        dceqDyn = dfun(x);
     end
    
    function varargout = objective(x,p)
                
        uvector = x(1+p.Nx*p.Nt:end); % extract
        u = reshape(uvector,p.Nt,p.Nu);
        beta = 1;
        L = beta*abs(u); % integrand
        %
        varargout{1} = p.dx*p.dt*sum(sum(L));
        %
    end
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
