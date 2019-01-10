function  AverageStochasticGradient(CPD,YT,varargin)
% description:  This function solves a particular optimal control problem using
%               the stochastic gradient descent algorithm. The restriction of the optimization 
%               problem is a parameter-dependent finite dimensional linear system. Then, the 
%               resulting states depend on a certain parameter. Hence, the functional is
%               constructed to control the average of the states with respect to this parameter
%               $$ \\frac{1}{\\vert \\mathcal{K} \\vert} \\sum_{\\nu \\in \\mathcal{K}}x(T,\\nu) = xt  $$
%               See Also in AverageClassicalGradient
% little_description: This function solves a particular optimal control problem using
%                       the stochastic gradient descent algorithm.
% autor: AnaN
% MandatoryInputs:   
%   iCPD: 
%    description: Control Parameter Dependent Problem 
%    class: ControlParameterDependent
%    dimension: [1x1]
%   xt: 
%    description: The final target. The system will be controlled to starting in x0 ending in xt.
%    class: double
%    dimension: [iCPD.Nx1]
% OptionalInputs:
%   tol:
%    description: tolerance of algorithm, this number is compare with the
%                   following error in order to stop the algorithm
%                   $$\\frac{\\vert \\vert u_{k+1}-u_{k}\\vert \\vert}{\\vert \\vert u_{k+1}\\vert
%                   \\vert}$$
%    class: double
%    dimension: [1x1]
%    default:   1e-5
%   beta:
%    description: This value is applied to regularize the control in the optimal control problem
%                   $$ \\min_{u \\in L^2(0,T)} J(u)=\\frac{1}{2} \\left( \\frac{1}{|\\mathcal{K}|} \\sum_{\\nu \\in \\mathcal{K}} x \\left( T, \\nu \\right) - xt \\right)^2  + \\frac{\\beta}{2} \\int_0^T u^2 \\mathrm{d}t, \\quad \\beta \\in \\mathbb{R}^+ $$ 
%    class: double
%    dimension: [1x1]
%    default:   1e-1
%   gamma0:
%    description: Initial step of the method. The control is update as follow
%                   $$u_{k+1} = u_{k} + \\gamma_{k} \\nabla J_{i_{k}}(u_{k})(u_{k}),$$
%                   where $\\gamma_{k} = \\gamma_0 * \\frac{1}/{\\sqrt{k}}$
%    class: double
%    dimension: [1x1]
%    default:   0.5
%   MaxIter:
%    description: Maximun of iterations of this method
%    class: double
%    dimension: [1x1]
%    default:   1000
    p = inputParser;
    addRequired(p,'ACProblem')
    addRequired(p,'xt',@xt_valid)
    addOptional(p,'tol',1e-5)
    addOptional(p,'beta',1e-1)
    addOptional(p,'gamma0',0.5)
    addOptional(p,'MaxIter',1000)
    
    parse(p,CPD,YT,varargin{:})

    tol     = p.Results.tol;
    beta    = p.Results.beta;
    gamma0   = p.Results.gamma0;
    MaxIter = p.Results.MaxIter;

    K = CPD.K;
    A = CPD.A;
    B = CPD.B;
    span = CPD.span;
    
    %% init
    tic;
    dt = span(2) - span(1); T  = span(end);
    parmsODE = {'dt',dt,'T',T};

    ParameticODE = LinearODE.empty;
    for index = 1:K
        % Create the ODE object
        ParameticODE(index) = LinearODE(A(:,:,index),B(:,:,index),parmsODE{:});
        % initial state
        ParameticODE(index).Y0 = CPD.x0;
    end

    %
    AdjointODEs =  LinearODE.empty;
    for index = 1:K
        Aadj = ParameticODE(index).A';
        Badj = ones(size(Aadj));
        AdjointODEs(index) = LinearODE(Aadj,Badj,parmsODE{:});
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
        solve(ParameticODE);
        % calculate mean state final vector of primal problems  
        YMend = forall({ParameticODE.Yend},'mean');

        % choose randomly a parameter $nu_{i_k}$ 
        j = randi([1,K]);
        % solve adjoint problem with 
        AdjointODEs(j).Y0 = -(YMend' - YT);
        solve(AdjointODEs(j));
        
        pM=AdjointODEs(j).Y;
        
        pM=pM*B(:,:,j);
        % reverse adjoint variable
        pM = flipud(pM);    
        % Control update
        U = ParameticODE(1).U; % catch control currently
        DU = beta*U - pM;
        
        gamma = gamma0/sqrt(iter);
        
        U = U - gamma*DU;
        % update control in primal problems 
        for index = 1:K
            ParameticODE(index).U = U;
        end
        % Control error
        % =============
        % Calculate area ratio  of Du^2 and u^2
        Au2   =  trapz(span,U.^2);
        %ADu2  =  trapz(span,Du.^2);
        %
        Jcurrent =  0.5*(YMend' - YT)'*(YMend' - YT) + 0.5*beta*Au2;
        
        if iter ~= 1
            error =  abs(Jhistory(iter-1) - Jcurrent);
        end
        
        % Save evolution
        xhistory{iter} = [ span',forall({ParameticODE.Y},'mean')];
        uhistory{iter} = [ span',U]; 
        error_history(iter) = error;
        Jhistory(iter) = Jcurrent;
    end
    %% Warring
    if MaxIter == iter  
        warning('The maximum iteration has been reached. Convergence may not have been achieved')
    end
    %%
    CPD.addata.xhistory = xhistory(1:(iter-1));
    CPD.addata.uhistory = uhistory(1:(iter-1));
    CPD.addata.error_history = error_history(1:(iter-1));
    CPD.addata.time_execution = toc;
    CPD.addata.Jhistory = Jhistory(1:(iter-1));
    %%
    function xt_valid(xt)
        [nrow, ncol] = size(xt);
        if nrow ~= CPD.N ||ncol~=1
           error(['The xt, target state must have a dimension: [',num2str(CPD.N),'x1].', ...
                   ' Your targer have a dimension: [',num2str(nrow),'x',num2str(ncol),']']);
        end
    end
end

