function varargout  = Control2Functional(iCP,Control,Time)
    % Give the Control Problem this function give a control U(t) you obtain
    % the functional value
    %%
    if nargin > 2
        Time = abs(Time);
        iCP.Dynamics.FinalTime = Time;
    end
    StateVector = GetNumericalDynamics(iCP,Control);
    J = GetNumericalFunctional(iCP,StateVector,Control);
    %%
    if nargout > 1        
        AdjointVector = GetNumericalAdjoint(iCP,Control,StateVector);
        dJ            = GetNumericalControlGradient(iCP,Control,StateVector,AdjointVector);
        %dJ(end,:) = 0;
        if nargin > 2 % tiempo
            dJ = dJ(:);
            DynamicsEqn   = iCP.Dynamics.DynamicEquation.Numeric(Time,StateVector(end,:)',Control(end,:)');
            
            pf =  AdjointVector(end,:)*DynamicsEqn + 1;
            L  = iCP.Functional.L.Numeric(Time,StateVector,Control);
            
            dJ(end + 1) = iCP.Dynamics.dt*(pf +  L);
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
    end
    
end