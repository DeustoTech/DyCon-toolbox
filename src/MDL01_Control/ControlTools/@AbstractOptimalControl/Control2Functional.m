function [Jfuntional, varargout ] = Control2Functional(iCP,U)
    % Give the Control Problem this function give a control U(t) you obtain
    % the functional value
    %%
    [~,Y] = solve(iCP.dynamics,'Control',U);
    Jfuntional = GetNumericalFunctional(iCP,Y,U);
    %%
    if nargout > 1
        T = iCP.dynamics.FinalTime;
        
        iCP.adjoint.dynamics.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Y(end,:)');
        P = GetNumericalAdjoint(iCP,U,Y);
        varargout{1} = 0.01*GetNumericalControlGradient(iCP,U,Y,P);
    end
    
end