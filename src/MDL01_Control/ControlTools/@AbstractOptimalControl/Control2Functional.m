function varargout  = Control2Functional(iCP,Control,Time)
    % Give the Control Problem this function give a control U(t) you obtain
    % the functional value
    %%
    if nargin > 2
        Time = abs(Time);
        iCP.Dynamics.FinalTime = Time;
    end
    StateVector = GetNumericalDynamics(iCP,Control);
    Control     = iCP.Dynamics.Control.Numeric;
    J = GetNumericalFunctional(iCP,StateVector,Control);
    %%
    if nargout > 1        
        AdjointVector = GetNumericalAdjoint(iCP,Control,StateVector);
        dJ            = GetNumericalControlGradient(iCP,Control,StateVector,AdjointVector);
        %dJ(end,:) = 0;
        if nargin > 2 % tiempo
            dJ = dJ(:);
            DynamicsEqn   = iCP.Dynamics.DynamicEquation.Num(Time,StateVector(end,:)',Control(end,:)');
            
            pf =  AdjointVector(end,:)*DynamicsEqn + 1;
            L  = iCP.Functional.Lagrange.Num(Time,StateVector,Control);
            
            dJ(end + 1) =   (pf +  L);
        end
    end
    
    
%     if nargout > 2        
%         Hess = GetNumericalHessian(iCP,Control,StateVector,AdjointVector);
%     end
    
    switch nargout
        case 1
            varargout{1} = J;
        case 2
            varargout{1} = J;
            varargout{2} = dJ;
        case 3
            varargout{1} = J;
            varargout{2} = dJ;
            varargout{3} = StateVector;
        case 4
            varargout{1} = J;
            varargout{2} = dJ;
            varargout{3} = StateVector;
            varargout{4} = AdjointVector;
        case 5
            varargout{1} = J;
            varargout{2} = dJ;
            varargout{3} = StateVector;
            varargout{4} = AdjointVector;
            varargout{5} = iCP.Dynamics.Control.Numeric;

    end
    
end