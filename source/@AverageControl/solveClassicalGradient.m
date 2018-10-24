function  [u,aditional_data] = solve_SG(ACProblem,xt,varargin)

%SOLVE_SG Summary of this function goes here
%   Detailed explanation goes here
    %% Variables 
    
    p = inputParser;
    addRequired(p,'ACProblem')
    addRequired(p,'xt')
    addOptional(p,'tol',1e-8)
    addOptional(p,'beta',1e-3)
    addOptional(p,'gamma',1)
    addOptional(p,'MaxIter',50)
    
    parse(p,ACProblem,xt,varargin{:})

    tol     = p.Results.tol;
    beta    = p.Results.beta;
    gamma   = p.Results.gamma;
    MaxIter = p.Results.MaxIter;

    K = ACProblem.K;
    A = ACProblem.A;
    B = ACProblem.B;
    span = ACProblem.span;
    
    %% init
    tic;
    primal_odes = zeros(1,ACProblem.K,'ode');
    for index = 1:K
        %
        primal_odes(index)      = ode(A(:,:,index),'B',B(:,:,index));
        % all have the same control
        primal_odes(index).u    = ACProblem.u0;
        % time intervals
        primal_odes(index).span = span;
        % initial state
        primal_odes(index).x0   = ACProblem.x0;
    end

    %
    adjoint_odes = zeros(1,K,'ode');
    for index = 1:K
        adjoint_odes(index)      = ode(A(:,:,index)');
        % all have the same control
        adjoint_odes(index).u    = ACProblem.u0;
        % time intervals
        adjoint_odes(index).span = span;
    end

  
    %%
    error = Inf;
    iter = 0;
    xhistory = {}; uhistory = {};  error_history = zeros(1,MaxIter);    % array here we will save the evolution of average vector states
    while (error > tol && iter < MaxIter)
        iter = iter + 1;
        % solve primal problem
        % ====================
        solve(primal_odes);
        % calculate mean state final vector of primal problems  
        xMend = forall({primal_odes.xend},'mean');

        % solve adjoints problems
        % =======================
        % update new initial state of all adjoint problems
        for iode = adjoint_odes
            iode.x0 = -(xMend' - xt);
        end
        % solve adjoints problems with the new initial state
        solve(adjoint_odes);

        % update control
        % ===============
        % calculate mean state vector of adjoints problems 
        pM = adjoint_odes(1).x*B(:,:,1);
        for index =2:K
            pM = pM + adjoint_odes(index).x*B(:,:,index);
        end
        pM = pM/K;
        % reverse adjoint variable
        pM = flipud(pM);    
        % Control update
        u = primal_odes(1).u; % catch control currently
        Du = beta*u - pM;
        u = u - gamma*Du;
        % update control in primal problems 
        for index = 1:K
            primal_odes(index).u = u;
        end
        % Control error
        % =============
        % Calculate area ratio  of Du^2 and u^2
        Au2   =  trapz(span,u.^2);
        ADu2  =  trapz(span,Du.^2);
        %
        error = sqrt(ADu2/Au2);
        % Save evolution
        xhistory{iter} = [ span',forall({primal_odes.x},'mean')];
        uhistory{iter} = [ span',u]; 
        error_history(iter) = error;
    end
    
        aditional_data.xhistory = xhistory;
        aditional_data.uhistory = uhistory;
        aditional_data.error_history = error_history;
        aditional_data.time_execution = toc;
end

