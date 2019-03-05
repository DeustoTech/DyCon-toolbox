function P = GetNumericalAdjoint(iCP)

        
        iCP.adjoint.ode.dt = iCP.ode.dt;
        iCP.adjoint.ode.FinalTime = iCP.ode.FinalTime;
        iCP.adjoint.ode.SolverParameters = iCP.ode.SolverParameters;
        iCP.adjoint.ode.MassMatrix = iCP.ode.MassMatrix;
        
        [~,P] = solve(iCP.adjoint.ode);
        P = flipud(P);
end

