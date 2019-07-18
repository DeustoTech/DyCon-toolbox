function fmincon(iCP1,varargin)
%FMINCON Summary of this function goes here
%   Detailed explanation goes here
    dynamics = iCP1.Dynamics;
    %
    U = zeros(dynamics.Nt,dynamics.ControlDimension);
    Y = zeros(dynamics.Nt,dynamics.StateDimension);

    if isempty(obj.Derivatives.ControlControl.Num) 
        GetSymCrossDerivatives(iCP1)
    end
    if  isempty(iCP1.Dynamics.Derivatives.Control.Num)
        GetSymCrossDerivatives(iCP1.Dynamics)
    end
    
    YU0 = [Y U];
    Udim = dynamics.ControlDimension;
    Ydim = dynamics.StateDimension;

    options = optimoptions('fmincon','display','iter',    ...
                           'MaxFunctionEvaluations',1e6,  ...
                           'SpecifyObjectiveGradient',true, ...
                           'CheckGradients',false,          ...
                           'SpecifyConstraintGradient',true, ...
                           'HessianFcn',@(YU,Lambda) Hessian(iCP1,YU,Lambda));
    %
    funobj = @(YU) StateControl2DiscrFunctional(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end));

    clear ConstraintDynamics
    YU = fmincon(funobj,YU0, ...
               [],[], ...
               [],[], ...
               [],[], ...
               @(YU) ConstraintDynamics(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end)),    ...
               options);

    iCP1.Dynamics.StateVector.Numeric = YU(:,1:Ydim);
    iCP1.Dynamics.Control.Numeric = YU(:,Ydim+1:end);

end

