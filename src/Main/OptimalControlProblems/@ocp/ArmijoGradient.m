function varargout = ArmijoGradient(iocp,ControlGuess,varargin)
%GRADIENTDESCENT 

    p = inputParser;

    SetDefaultGradientOptions(p)

    addOptional(p,'InitialLengthStep',1e-3)
    addOptional(p,'MaxLengthStep',1000)
    addOptional(p,'FunctionRelativeTol',1e-5)

    parse(p,iocp,ControlGuess,varargin{:})

    
    %% Parameters
    LengthStep    = p.Results.InitialLengthStep;
    MinLengthStep = p.Results.MinLengthStep;
    MaxIter       = p.Results.MaxIter;
    tol           = p.Results.tol;
    EachIter      = p.Results.EachIter;
    MaxLengthStep = p.Results.MaxLengthStep;
    FunctionRelativeTol = p.Results.FunctionRelativeTol;
    %% Classical Gradient
    Uta = ControlGuess;
    [dUta,Ja,~] = Control2ControlGradient(iocp,Uta);
    
    iter_display = 0;
    for iter = 1:MaxIter
        % solve Primal System with current control
        Utc = Uta - LengthStep*dUta;
        [dUtc,Jc,Xsolc] = Control2ControlGradient(iocp,Utc);
        while full(Jc) >= full(Ja) 
            % Update Control
            LengthStep = LengthStep*0.5;

            if LengthStep < MinLengthStep
                break
            end
            Utc = Uta - LengthStep*dUta;
            [dUtc,Jc,Xsolc] = Control2ControlGradient(iocp,Utc);
        end

        if isnan(full(Jc))
            fprintf(2,"\n   Functional Value is nan!! \n\n")
            break
        end
        if LengthStep < MinLengthStep
            fprintf(2,"\n    Mininum Length Step have been achieve !! \n\n")
            break
        end
        
        if LengthStep < MaxLengthStep
            LengthStep = 2*LengthStep;
        end
        
        abs_error = abs(full(Jc)-full(Ja));
        relative_error = abs_error/full(Jc);
        if relative_error < FunctionRelativeTol
            fprintf(2,'\n Function Relative Tolerance achieve!\n')
            break
        end
        Ja  = Jc; Uta = Utc ; dUta = dUtc;
        % Compute Erro
        err = norm_fro(dUtc);
        % Look if error is small 
        if full(err) < tol
            break
            fprintf(2,'\n Norm of Gradient Tolerance achieve!\n')
        end
        %
        if ~isempty(iocp.TargetState)
            TargetDistance = norm(iocp.TargetState  - Xsolc(:,end));
        else
            TargetDistance = nan;
        end
        %
        if mod(iter,EachIter) == 0
            iter_display = iter_display + 1;
            if mod(iter_display,10) == 1
                fprintf(2,"====================================================================================================================\n")
                fprintf(2,"|   iter   |   norm(dJ/du)  |    abs(Jc-Ja)   |  abs(Jc-Ja)/Jc  |  LengthStep  |       J       |   Distance2Target |\n")
                fprintf(2,"====================================================================================================================\n")

            else
                fprintf( "|   "+num2str(iter,'%.3d')                   + "    |    " + ...
                                num2str(full(err),'%10.3e')            + "   |    "   + ...
                                num2str(full(abs_error),'%10.3e') + "    |   "              + ...
                                num2str(full(relative_error),'%10.3e') + "    |   "   + ...
                                num2str(LengthStep,'%10.2e')           + "   |  "    + ...
                                num2str(full(Jc),'%10.5e')             + "  |       "+ ...
                                num2str(full(TargetDistance))    +  "          |\n"  )
            end
        end
    end
    if iter == MaxIter
        fprintf(2,'\n       Max Iter achieve!!\n')
    end
    switch nargout
            case 1
                varargout{1} = full(Utc);
            case 2
                varargout{1} = full(Utc);
                varargout{2} = full(Xsolc);
    end
    

