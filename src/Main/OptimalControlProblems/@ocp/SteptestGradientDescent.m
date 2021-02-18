function varargout = SteptestGradientDescent(iocp,ControlGuess,varargin)
%GRADIENTDESCENT 

    p = inputParser;

    SetDefaultGradientOptions(p)

    addOptional(p,'InitialLengthStep',1e-4)

    parse(p,iocp,ControlGuess,varargin{:})

    
    %% Parameters
    LengthStep    = p.Results.InitialLengthStep;
    MinLengthStep = p.Results.MinLengthStep;
    MaxIter       = p.Results.MaxIter;
    tol           = p.Results.tol;
    EachIter      = p.Results.EachIter;
    %%
    %%
    if ~iocp.HasGradients
        PreIndirectMethod(iocp)
    end
    %% Classical Gradient
    Utb = ControlGuess;
    [dUtb,~,~] = Control2ControlGradient(iocp,Utb);
    
    ls = casadi.SX.sym('ls');
    for iter = 1:MaxIter
        % solve Primal System with current control
        fobj = @(LengthStep) LengthStep2Functional(iocp,LengthStep);
        
        nlp = struct('x',ls, 'f',fobj(ls));
        opt_ipopt = struct('print_level'    ,   0);
                       
        opt = struct('print_time',false,'verbose_init',false,'ipopt',opt_ipopt);
        
        S = casadi.nlpsol('S', 'ipopt', nlp,opt);
        r = S('x0',0);
        OptimalLengthStep = full(r.x);
        %%%
        Utb = Utb - OptimalLengthStep*dUtb;
        [dUtb,Jc,Xsolc] = Control2ControlGradient(iocp,Utb);

        % Compute Erro
        error = norm_fro(dUtb);
        % Look if error is small 
        if full(error) < tol
            break
        end
        if abs(OptimalLengthStep) < MinLengthStep
            fprintf("\n    Mininum Length Step have been achive !! \n\n")
            break
        end
        %
        if ~isempty(iocp.TargetState)
            TargetDistance = norm(iocp.TargetState  - Xsolc(:,end));
        else
            TargetDistance = nan;
        end
        %

        if mod(iter,EachIter) == 0
        fprintf("iteration: "    + num2str(iter,'%.3d')             +  ...
                " | error: "     + num2str(full(error),'%10.3e')          +  ...
                " | LengthStep: "+ num2str(full(OptimalLengthStep),'%10.3e')     +  ...
                " | J: "         + num2str(full(Jc),'%10.3e')             +  ...
                " | Distance2Target: " + num2str(TargetDistance)    +  ...
                " \n"  )
        end
    end

    switch nargout
        case 1
            varargout{1} = full(Utb);
        case 2
            varargout{1} = full(Utb);
            varargout{2} = full(Xsolc);
    end
    
    function J = LengthStep2Functional(iocp,LengthStep)
        Utfun = Utb - LengthStep*dUtb;
        [~,J,~] = Control2ControlGradient(iocp,Utfun);
    end
end

