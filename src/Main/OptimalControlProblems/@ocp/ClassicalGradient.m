function varargout = ClassicalGradient(iocp,ControlGuess,varargin)
%GRADIENTDESCENT 

    p = inputParser;

    SetDefaultGradientOptions(p)
    
    addOptional(p,'LengthStep',1e-4)

    parse(p,iocp,ControlGuess,varargin{:})

    %%
    %% Parameters
    LengthStep = p.Results.LengthStep;
    MaxIter    = p.Results.MaxIter;
    tol        = p.Results.tol;
    EachIter   = p.Results.EachIter;
    %% Classical Gradient
    Ut = ControlGuess;
    for iter = 1:MaxIter
        % solve Primal System with current control
        [dU,Jc,Xsol] = Control2ControlGradient(iocp,Ut);
        % Update Control
        Ut = Ut - LengthStep*dU;
        % Compute Error
        error = norm_fro(dU);
        % Look if error is small 
        if full(error) < tol
            break
        end
        %
        if ~isempty(iocp.TargetState)
            TargetDistance = norm(iocp.TargetState  - Xsol(:,end));
        else 
            TargetDistance = nan;
        end
        if mod(iter,EachIter) == 0
        fprintf("iteration: "    + num2str(iter,'%.3d')             +  ...
                " | error: "     + num2str(full(error),'%10.3e')          +  ...
                " | LengthStep: "+ num2str(LengthStep,'%10.3e')     +  ...
                " | J: "         + num2str(full(Jc),'%10.3e')             +  ...
                " | Distance2Target: " + num2str(full(TargetDistance))    +  ...
                " \n"  )
        end
    end

    switch nargout
        case 1
            varargout{1} = full(Ut);
        case 2
            varargout{1} = full(Ut);
            varargout{2} = full(Xsol);
    end
end

