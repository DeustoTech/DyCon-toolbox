function [Jfuntional, varargout ] = Control2Functional(iCP,U)

    [~,Y] = solve(iCP.ode,'Control',U);
    Jfuntional = GetNumericalFunctional(iCP,Y,U);

    if nargout > 1
        T = iCP.ode.FinalTime;
        
        iCP.adjoint.ode.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Y(end,:)');
        P = GetNumericalAdjoint(iCP,U,Y);
        varargout{1} = 0.01*GetNumericalGradient(iCP,U,Y,P);
    end
    
end