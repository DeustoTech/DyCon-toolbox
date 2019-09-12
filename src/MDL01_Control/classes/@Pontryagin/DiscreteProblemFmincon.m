function varargout = DiscreteProblemFmincon(OCP,varargin)
% Resolvemos el problema completamente discreto con ayuda de fmincon
    % 
    dyn = OCP.Dynamics;
    Udim = dyn.ControlDimension;
    Ydim = dyn.StateDimension;
    Nt   = dyn.Nt;
    %% Input parameters Management 
    p = inputParser;
    addRequired(p,'OCP')
    addOptional(p,'ControlGuess',ones(Nt,Udim))
    addOptional(p,'StateGuess',ones(Nt,Ydim))
    %
    fminconOptions = optimoptions('fmincon','display','iter',    ...
                           'MaxFunctionEvaluations',1e6,  ...
                           'SpecifyObjectiveGradient',true, ...
                           'CheckGradients',false,          ...
                           'SpecifyConstraintGradient',true); % , ...
                           % 'HessianFcn',@(YU,Lambda) Hessian(OCP,YU,Lambda));
                       
    addOptional(p,'fminconOptions',fminconOptions)

    %
    parse(p,OCP,varargin{:})
    %
    Y0              = p.Results.StateGuess;
    U0              = p.Results.ControlGuess;
    fminconOptions  = p.Results.fminconOptions;
    
    %% We check and calculate if we have the cross derivatives and the second derivatives.
    if isempty(dyn.Derivatives.ControlControl.Num) 
        GetSymCrossDerivatives(OCP)
    end
    if  isempty(OCP.Dynamics.Derivatives.ControlControl.Num)
        GetSymCrossDerivatives(OCP.Dynamics)
    end
      
    %% low and up boundaries
    if ~isempty(OCP.Constraints.MaxControl)
        Umax = repmat(OCP.Constraints.MaxControl,Nt,Udim);
    else
        Umax = repmat(+Inf,Nt,Udim);
    end
    if ~isempty(OCP.Constraints.MinControl)
        Umin = repmat(OCP.Constraints.MinControl,Nt,Udim);
    else
        Umin = repmat(-Inf,Nt,Udim);
    end
    
    Ymax = repmat(+Inf,Nt,Ydim);
    Ymin = repmat(-Inf,Nt,Ydim);
    
    YUmax = [Ymax Umax];
    YUmin = [Ymin Umin];
    %% We create the objective function. This is the Discrete Functional
    
    YU0 = [Y0 U0];
    funobj = @(YU) StateControl2DiscrFunctional(OCP,YU(:,1:Ydim),YU(:,Ydim+1:end));
    clear ConstraintDynamics
    
    %%
    [YU,JOpt] = fmincon(funobj,YU0, ...
               [],[], ...
               [],[], ...
               YUmin,YUmax, ...     % low constraints - up constraints
               @(YU) ConstraintDynamics(OCP,YU(:,1:Ydim),YU(:,Ydim+1:end)),    ... % <-- We set the dynamics as discrete contraint
               fminconOptions);

    OCP.Dynamics.StateVector.Numeric = YU(:,1:Ydim);
    OCP.Dynamics.Control.Numeric     = YU(:,Ydim+1:end);
    %%
    switch nargout
        case 1
            varargout{1} = OCP.Dynamics.Control.Numeric;
        case 2 
            varargout{1} = OCP.Dynamics.Control.Numeric;
            varargout{2} = JOpt;
        case 3 
            varargout{1} = OCP.Dynamics.Control.Numeric;
            varargout{2} = JOpt;
            varargout{3} = OCP.Dynamics.StateVector.Numeric;
    end
end

