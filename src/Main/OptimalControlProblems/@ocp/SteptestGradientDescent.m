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
    %% Classical Gradient
    Utb = ControlGuess;
    [dUtb,~,~] = Control2ControlGradient(iocp,Utb);
    
    for iter = 1:MaxIter
        % solve Primal System with current control
        fobj = @(LengthStep) LengthStep2Functional(iocp,LengthStep);
        
        options  = optimoptions(@fminunc,'display','off','SpecifyObjectiveGradient',false,'MaxFunEvals',10,'StepTolerance',1e-8);
        OptimalLengthStep = fminunc(fobj,1e-5,options);

        Utb = Utb - OptimalLengthStep*dUtb;
        [dUtb,Jc,Xsolc] = Control2ControlGradient(iocp,Utb);

        % Compute Erro
        error = norm(dUtb);
        % Look if error is small 
        if error < tol
            break
        end
        if abs(OptimalLengthStep) < MinLengthStep
            fprintf("\n    Mininum Length Step have been achive !! \n\n")
            break
        end
        %
        TargetDistance = norm(iocp.TargetState  - Xsolc(:,end));

        if mod(iter,EachIter) == 0
        fprintf("iteration: "    + num2str(iter,'%.3d')             +  ...
                " | error: "     + num2str(error,'%10.3e')          +  ...
                " | LengthStep: "+ num2str(OptimalLengthStep,'%10.3e')     +  ...
                " | J: "         + num2str(Jc,'%10.3e')             +  ...
                " | Distance2Target: " + num2str(TargetDistance)    +  ...
                " \n"  )
        end
    end

    switch nargout
        case 1
            varargout{1} = Utb;
        case 2
            varargout{1} = Utb;
            varargout{2} = Xsolc;
    end
    
    function J = LengthStep2Functional(iocp,LengthStep)
        Utfun = Utb - LengthStep*dUtb;
        [~,J,~] = Control2ControlGradient(iocp,Utfun);
    end
end

