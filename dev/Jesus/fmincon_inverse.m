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

subplot(2,2,1)
plot(p.solution.yopt(1,:))
hold on
plot(p.y0,'--')
legend({'Estimado','Real'})
title('initial')

subplot(2,2,2)
plot(p.solution.yopt(end,:))
hold on
plot(p.yf,'--')
legend({'Estimado','Real'})
title('final')

subplot(2,2,3)
surf(p.xms,p.tms,p.solution.yopt )
title('evolution estimada')


subplot(2,2,4)
surf(p.xms,p.tms,p.yreal )
title('evolution real')


function p = Method_SingleStep_fun
    %% Dynamics 
    p.T  = 0.02;
    %%
    p.Nx = 20;
    p.Nt = 80; p.dt = p.T/(p.Nt-1);
    %%
    p.xline = linspace(-1,1,p.Nx);
    p.tline = linspace( 0,p.T,p.Nt);
    p.dx = p.xline(2) - p.xline(1);
    %%
    
    p.A = FDLaplacian(p.xline);
    % problem parameters
    %
    alpha = 0.5*p.dx;
    p.y0 = 1*exp(-p.xline.^2/alpha.^2) + ...
           5*exp(-(p.xline - 0.5).^2/alpha.^2) + ...
           10*exp(-(p.xline + 0.6).^2/alpha.^2);
    
    %% Target

    p.dynamics = pde('A',p.A);
    p.dynamics.mesh = p.xline;
    p.dynamics.Solver = @eulere;

    p.dynamics.FinalTime = p.T;
    p.dynamics.dt = p.T/(p.Nt-1);
    
    p.dynamics.InitialCondition = p.y0;
    [~ , ytarget ] = solve(p.dynamics);
    p.yreal = ytarget;
    p.yf =  ytarget(end,:)';
    %%
    
    x0 = 1 + zeros(p.Nt*p.Nx,1); % initial guess (all zeros)
    
    options = optimoptions(@fmincon,'display','iter','MaxFunctionEvaluations',1e5,'UseParallel',true); % options
    % solve the problem
    [x ,J] = fmincon(@(x) objective(x,p),x0,[],[],[],[],[],[],@(x) constraints(x,p),options);
    %x = fmincon(@(x) objective(x,p),x0,[],[],[],[],[],[],[],options);
    % obtain the optimal solution
    yopt = x(1:p.Nx*p.Nt); % extract
    yopt = reshape(yopt,p.Nt,p.Nx);
       
    p.solution.yopt = yopt;
    
    p.solution.Jopt = J;
    %%
    % objective function
    function f = objective(x,p)
        x = reshape(x , p.Nt , p.Nx);
        %f = trapz(p.xline,(x(end,:).^2)); % calculate objective
        f = trapz(p.tline,trapz(p.xline,(abs(x)),2)); % calculate objective

    end
    % constraint function
    function [c,ceq] = constraints(x,p)
        
        y = x(1:p.Nx*p.Nt); % extract
        c = y';
        %c = [];
        y = reshape(y,p.Nt,p.Nx);
        % 
        F = p.A*y';
        F = F';
        % final state conditions
        ceqFinal = y(end,:)'  - p.yf; 
        % defect constraints
        ceqDyn  = zeros(p.Nx,p.Nt -1);
        for i = 1:p.Nx
            ceqDyn(i,:) = (y(2:p.Nt,i) - y(1:p.Nt-1,i) - p.dt/2.*( F(1:p.Nt-1,i) + F(2:p.Nt,i) ));
        end
        ceqDyn = reshape(ceqDyn,1,p.Nx*(p.Nt-1));
        ceq = [ceqFinal;ceqDyn']; % combine constraints
    end

end
