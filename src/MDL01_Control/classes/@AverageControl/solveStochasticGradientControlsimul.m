function  solveStochasticGradientControlsimul(ACProblem,xt,varargin)

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
    error = Inf;
    iter = 0;
    % array here we will save the evolution of average vector states
    xhistory = {};
    uhistory = {};
    error_history = zeros(1,MaxIter);
    Jhistory =  zeros(1,MaxIter); 

    while (error > tol && iter < MaxIter)
        iter = iter + 1;
        % solve primal problem
        % ====================
        solve(primal_odes);
        % calculate mean state final vector of primal problems  
        xMend = forall({primal_odes.xend},'mean');

        % choose randomly a parameter $nu_{i_k}$ 
        j = randi([1,K]);
        % solve adjoint problem with 
        adjoint_odes(j).x0 = -(xMend' - xt);
        solve(adjoint_odes(j));
        
        pM=adjoint_odes(j).x;
        
        pM=pM*B(:,:,j);
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
        %ADu2  =  trapz(span,Du.^2);
        %
        Jcurrent =  0.5*(xMend' - xt)'*(xMend' - xt) + 0.5*beta*Au2;
        
        if iter ~= 1
            error =  abs(Jhistory(iter-1) - Jcurrent);
        end
        
        % Save evolution
        xhistory{iter} = [ span',forall({primal_odes.x},'mean')];
        uhistory{iter} = [ span',u]; 
        error_history(iter) = error;
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

