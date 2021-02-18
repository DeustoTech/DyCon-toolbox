function varargout = ConjugateGradient(iocp,ControlGuess,varargin)
%GRADIENTDESCENT 

    p = inputParser;

    SetDefaultGradientOptions(p)

    addOptional(p,'GuessLengthStep',1e-6)

    parse(p,iocp,ControlGuess,varargin{:})
    
    %% Parameters
     
    GuessLengthStep = p.Results.GuessLengthStep;
    MinLengthStep   = p.Results.MinLengthStep;
    MaxIter         = p.Results.MaxIter;
    tol             = p.Results.tol;
    EachIter        = p.Results.EachIter;
    %%     
    %%
    if ~iocp.HasGradients
        PreIndirectMethod(iocp)
    end
    %% Classical Gradient
    Utb = ControlGuess;
    [dUtb,~,~] = Control2ControlGradient(iocp,Utb);
    stb = - dUtb;
    
    ls = casadi.SX.sym('ls');

    for iter = 1:MaxIter
        % Choose Optimal Length Step in st direction.
        fobj = @(LengthStep) LengthStep2Functional(iocp,LengthStep);
        
        nlp = struct('x',ls, 'f',fobj(ls));
        opt_ipopt = struct('print_level'    ,   0);
                       
        opt = struct('print_time',false,'verbose_init',false,'ipopt',opt_ipopt);
        
        S = casadi.nlpsol('S', 'ipopt', nlp,opt);
        r = S('x0',GuessLengthStep);
        OptimalLengthStep = full(r.x);
        
        % Compute Utc, Current Control, with the optimal length step
        Utc = Utb + OptimalLengthStep*stb;
        [dUtc,Jc,Xsolc] = Control2ControlGradient(iocp,Utc);
        %
        GuessLengthStep = OptimalLengthStep;
        % Compute beta, this paramter represent the fraction of new
        % gradient and previus gradient.
        beta = dotprod(iocp,dUtc,dUtc)/dotprod(iocp,dUtb,dUtb);
        % With this compute the new direction of descent
        stc  = -dUtc + beta*stb;
        % Save current information in before variables 
        dUtb = dUtc;
        stb  = stc;
        Utb  = Utc;
        Jb   = Jc;
        
        % Compute Error
        normGradient = sqrt(dotprod(iocp,dUtc,dUtc));
        error = normGradient;
        % Look if error is small 
        if full(error) < tol
            break
        end
        % if Optimal LengthSteo is very tiny, the best option is stop the
        % process
        if abs(OptimalLengthStep) < MinLengthStep
            fprintf("\n    Mininum Length Step have been achive !! \n\n")
            break
        end
        % Show information by iteration
        if ~isempty(iocp.TargetState)
            TargetDistance = norm(iocp.TargetState  - Xsolc(:,end));
        else 
            TargetDistance = nan;
        end
        if mod(iter,EachIter) == 0
        fprintf("iteration: "    + num2str(iter,'%.3d')                    +  ...
                " | error: "     + num2str(full(error),'%10.3e')                 +  ...
                " | norm(dJ): "     + num2str(full(normGradient),'%10.3e')                 +  ...
                " | LengthStep: "+ num2str(OptimalLengthStep,'%+10.3e')     +  ...
                " | beta: "+ num2str(full(beta),'%10.3e')     +  ...
                " | J: "         + num2str(full(Jc),'%10.4e')             +  ...
                " | Distance2Target: " + num2str(full(TargetDistance))    +  ...
                " \n"  )
        end
        % 
    end

    switch nargout
        case 1
            varargout{1} = Utb;
        case 2
            varargout{1} = Utb;
            varargout{2} = Xsolc;
    end
    
    function J = LengthStep2Functional(iocp,LengthStep)
        Utfun = Utb + LengthStep*stb;
        [~,J,~] = Control2ControlGradient(iocp,Utfun);
        J = full(J);
    end
end

