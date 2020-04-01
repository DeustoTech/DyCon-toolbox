function varargout = ArmijoGradient(iocp,ControlGuess,varargin)
%GRADIENTDESCENT 

    p = inputParser;

    SetDefaultGradientOptions(p)

    addOptional(p,'InitialLengthStep',1e-3)
    addOptional(p,'MaxLengthStep',1000)

    parse(p,iocp,ControlGuess,varargin{:})

    
    %% Parameters
    LengthStep    = p.Results.InitialLengthStep;
    MinLengthStep = p.Results.MinLengthStep;
    MaxIter       = p.Results.MaxIter;
    tol           = p.Results.tol;
    EachIter      = p.Results.EachIter;
    MaxLengthStep = p.Results.MaxLengthStep;
    %% Classical Gradient
    Uta = ControlGuess;
    [dUta,Ja,~] = Control2ControlGradient(iocp,Uta);
    

    for iter = 1:MaxIter
        % solve Primal System with current control
        Utc = Uta - LengthStep*dUta;
        [dUtc,Jc,Xsolc] = Control2ControlGradient(iocp,Utc);
        while full(Jc) > full(Ja) || isnan(full(Jc)) 
            % Update Control
            LengthStep = LengthStep*0.25;
            fprintf("Length Step has been change: LenghtStep = "+LengthStep+"\n")

            if LengthStep < MinLengthStep
                break
            end
            Utc = Uta - LengthStep*dUta;
            [dUtc,Jc,Xsolc] = Control2ControlGradient(iocp,Utc);
        end
        if LengthStep < MinLengthStep
            fprintf("\n    Mininum Length Step have been achive !! \n\n")
            break
        end
        
%         if isnan(Jc)
%            error('J = nan');
%         end
        if LengthStep < MaxLengthStep
            LengthStep = 2*LengthStep;
        end
        Ja  = Jc; Uta = Utc ; dUta = dUtc;
        % Compute Erro
        err = norm_fro(dUtc);
        % Look if error is small 
        if full(err) < tol
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
        fprintf("iter: "    + num2str(iter,'%.3d')             +  ...
                " | error: "     + num2str(full(err),'%10.3e')          +  ...
                " | LengthStep: "+ num2str(LengthStep,'%10.2e')     +  ...
                " | J: "         + num2str(full(Jc),'%10.5e')             +  ...
                " | Distance2Target: " + num2str(full(TargetDistance))    +  ...
                " \n"  )
        end
    end

    switch nargout
        case 1
            varargout{1} = full(Utc);
        case 2
            varargout{1} = full(Utc);
            varargout{2} = full(Xsolc);
    end
end

