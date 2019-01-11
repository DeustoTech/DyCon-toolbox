function  SimultaneousClassicalGradient(iCPD,xt,varargin)
% description:  The Simultaneous Classical Gradient solves an optimal control problem 
%               which is constructed to control each statein the last time
%               and a given final target. This function solve a particular optimal control problem using
%               the classical gradient descent algorithm. The restriction of the optimization 
%               problem is a parameter-dependent finite dimensional linear system. Then, the 
%               resulting states depend on a certain parameter. Hence, the functional is
%               constructed to control each state with respect to this parameter
%               $$ x(T,\\nu) = xt \\quad \\forall \\nu \\in \\mathcal{K}  $$.
%               See Also in AverageClassicalGradient
% little_description: The Simultaneous Classical Gradient solves an optimal control problem 
%                       which is constructed to control each statein the last time
%                       and a given final target.
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
%    description:  tolerance of algorithm, this number is compare with the
%                   following error in order to stop the algorithm
%                   $$\\frac{\\vert \\vert u_{k+1}-u_{k}\\vert \\vert}{\\vert \\vert u_{k+1}\\vert
%                   \\vert}$$
%    class: double
%    dimension: [1x1]
%    default:   1e-5
%   beta:
%    description: This value is applied to regularize the control in the optimal control problem
%                   $$ \\min_{u \\in L^2(0,T)} J(u)=\\frac{1}{2}  \\frac{1}{|\\mathcal{K}|} \\sum_{\\nu \\in \\mathcal{K}}\\left( x \\left( T, \\nu \\right) - xt \\right)^2  + \\frac{\\beta}{2} \\int_0^T u^2 \\mathrm{d}t, \\quad \\beta \\in \\mathbb{R}^+ $$ 
%    class: double
%    dimension: [1x1]
%    default:   1e-1
%   gamma0:
%    description: Initial step of the method. The control is update as follow
%                   $$u_{k+1} = u_{k} + \\gamma_{k} \\nabla J(u_{k}),$$
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
    addRequired(p,'iCPD')
    addRequired(p,'xt',@xt_valid)
    addOptional(p,'tol',1e-5)
    addOptional(p,'beta',1e-1)
    addOptional(p,'gamma0',0.5)
    addOptional(p,'MaxIter',1000)
    
    parse(p,iCPD,xt,varargin{:})

    tol     = p.Results.tol;
    beta    = p.Results.beta;
    gamma0   = p.Results.gamma0;
    MaxIter = p.Results.MaxIter;

    K = iCPD.K;
    A = iCPD.A;
    B = iCPD.B;
    span = iCPD.span;
    
    %% init
    tic;
    dt = span(2) - span(1); T  = span(end);
    parmsODE = {'dt',dt,'T',T};
    ParameticODE = LinearODE.empty;
    for index = 1:K
        %
        ParameticODE(index)      = LinearODE(A(:,:,index),B(:,:,index),parmsODE{:});
        % all have the same control
        ParameticODE(index).U    = iCPD.u0;
        % initial state
        ParameticODE(index).Y0   = iCPD.x0;
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

    while (error > tol && iter < MaxIter)
        iter = iter + 1;
        % solve primal problem
        % ====================
        solve(ParameticODE);

        % solve adjoints problems
        % =======================
        % update new initial state of all adjoint problems

        for index = 1:length(AdjointODEs)
            AdjointODEs(index).Y0 = -(ParameticODE(index).Yend' - xt);
        end
       
        % solve adjoints problems with the new initial state
        solve(AdjointODEs);

        % update control
        % ===============
        % calculate mean state vector of adjoints problems 
        pM = AdjointODEs(1).Y*B(:,:,1);
        for index =2:K
            pM = pM + AdjointODEs(index).Y*B(:,:,index);
        end
        pM = pM/K;
        
        % reverse adjoint variable
        pM = flipud(pM); 
        
        % Control update
        U = ParameticODE(1).U; % catch control currently
        Du = beta*U - pM;
        gamma=gamma0/sqrt(iter);
        Ua = U;
        U = U - gamma*Du;
        
        % update control in primal problems 
        for index = 1:K
            ParameticODE(index).U = U;
        end
        
        % Control error
        Au2  =  trapz(span,(U).^2);
        ADu2  =  trapz(span,(U-Ua).^2);
       
        error = sqrt(ADu2/Au2);
        
        % Save evolution
        xhistory{iter} = [ span',forall({ParameticODE.Y},'mean')];
        uhistory{iter} = [ span',U]; 
        error_history(iter) = error;
    end
    %% Warring
    if MaxIter == iter  
        warning('The maximum iteration has been reached. Convergence may not have been achieved')
    end
    %%
    iCPD.addata.xhistory = xhistory(1:(iter-1));
    iCPD.addata.uhistory = uhistory(1:(iter-1));
    iCPD.addata.Jhistory = [];

    iCPD.addata.error_history = error_history(1:(iter-1));
    iCPD.addata.time_execution = toc;

    %%
    function xt_valid(xt)
        [nrow, ncol] = size(xt);
        if nrow ~= iCPD.N ||ncol~=1
           error(['The xt, target state must have a dimension: [',num2str(iCPD.N),'x1].', ...
                   ' Your targer have a dimension: [',num2str(nrow),'x',num2str(ncol),']']);
        end
    end
end

