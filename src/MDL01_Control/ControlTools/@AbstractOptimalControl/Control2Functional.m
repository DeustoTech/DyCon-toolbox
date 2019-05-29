function varargout  = Control2Functional(iCP,Control,Time)
    % Give the Control Problem this function give a control U(t) you obtain
    % the functional value
    %%
    if nargin > 2
        iCP.Dynamics.FinalTime = Time;
    end
    StateVector = GetNumericalDynamics(iCP,Control);
    J = GetNumericalFunctional(iCP,StateVector,Control);
    %%
    if nargout > 1        
        AdjointVector = GetNumericalAdjoint(iCP,Control,StateVector);
        dJ            = GetNumericalControlGradient(iCP,Control,StateVector,AdjointVector);
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