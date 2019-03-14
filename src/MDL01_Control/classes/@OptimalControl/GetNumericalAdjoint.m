function P = GetNumericalAdjoint(iCP,U,Y)

        
        iCP.adjoint.ode.dt = iCP.ode.dt;
        iCP.adjoint.ode.FinalTime = iCP.ode.FinalTime;
        iCP.adjoint.ode.SolverParameters = iCP.ode.SolverParameters;
        iCP.adjoint.ode.MassMatrix = iCP.ode.MassMatrix;
        
        if iCP.adjoint.ode.lineal
            [~,P] = solve(iCP.adjoint.ode);
        else
            Control = [Y U];
            [~,P] = solve(iCP.adjoint.ode,'Control',Control);
        end
        P = flipud(P);

end

