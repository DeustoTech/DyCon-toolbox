function  solveClassicalGradient(ACProblem,xt,varargin)

%SOLVE_SG Summary of this function goes here
%   Detailed explanation goes here
    %% Variables 
    
    p = inputParser;
    addRequired(p,'ACProblem')
    addRequired(p,'xt',@xt_valid)
    addOptional(p,'tol',1e-5)
    addOptional(p,'beta',1e-1)
    addOptional(p,'gamma',0.5)
    addOptional(p,'MaxIter',100)
    
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
    primal_odes = zeros(1,ACProblem.K,'LinearODE');
    for index = 1:K
        %
        primal_odes(index)      = LinearODE(A(:,:,index),'B',B(:,:,index));
        % all have the same control
        primal_odes(index).u    = ACProblem.u0;
        % time intervals
        primal_odes(index).span = span;
        % initial state
        primal_odes(index).x0   = ACProblem.x0;
    end

    %
    adjoint_odes = zeros(1,K,'LinearODE');
    for index = 1:K
        adjoint_odes(index)      = LinearODE(A(:,:,index)');
        % all have the same control
        adjoint_odes(index).u    = ACProblem.u0;
        % time intervals
        adjoint_odes(index).span = span;
    end

  
    %%
    error_value = Inf;
    iter = 0;
    % array here we will save the evolution of average vector states
    xhistory = {};
    uhistory = {}; 
    error_history = zeros(1,MaxIter); 
    Jhistory =  zeros(1,MaxIter); 
    while (error_value > tol && iter < MaxIter)
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
        Au2   =  trapz(span,u.^2);
        %
        Jcurrent =  0.5*(xMend' - xt)'*(xMend' - xt) + 0.5*beta*Au2;
        
        if iter ~= 1
            error_value =  abs(Jhistory(iter-1) - Jcurrent);
        end
        
        % Save evolution
        xhistory{iter} = [ span',forall({primal_odes.x},'mean')];
        uhistory{iter} = [ span',u]; 
        error_history(iter) = error_value;
        Jhistory(iter) = Jcurrent;

    end
    %% Warring
    if MaxIter == iter  
        warning('The maximum iteration has been reached. Convergence may not have been achieved')
    end
    %%
    ACProblem.addata.xhistory = xhistory(1:(iter-1));
    ACProblem.addata.uhistory = uhistory(1:(iter-1));
    ACProblem.addata.error_history = error_history(1:(iter-1));
    ACProblem.addata.time_execution = toc;
    ACProblem.addata.Jhistory = Jhistory(1:(iter-1));
    %%
    function xt_valid(xt)
        [nrow, ncol] = size(xt);
        if nrow ~= ACProblem.N ||ncol~=1
           error(['The xt, target state must have a dimension: [',num2str(ACProblem.N),'x1].', ...
                   ' Your targer have a dimension: [',num2str(nrow),'x',num2str(ncol),']']);
        end
    end
end

