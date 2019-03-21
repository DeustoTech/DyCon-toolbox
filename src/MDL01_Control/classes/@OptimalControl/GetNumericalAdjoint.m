function P = GetNumericalAdjoint(iCP,U,Y)

        T = iCP.ode.FinalTime;
        iCP.adjoint.ode.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Y(end,:)');

        iCP.adjoint.ode.dt = iCP.ode.dt;
        iCP.adjoint.ode.FinalTime = iCP.ode.FinalTime;
        iCP.adjoint.ode.SolverParameters = iCP.ode.SolverParameters;
        iCP.adjoint.ode.MassMatrix = iCP.ode.MassMatrix;
        iCP.adjoint.ode.Solver = iCP.ode.Solver;
        
        if iCP.adjoint.ode.lineal
            [~,P] = solve(iCP.adjoint.ode);
        else
            Control = [Y U];
            Control = flipud(Control);
            [~,P] = solve(iCP.adjoint.ode,'Control',Control);
        end
        P = flipud(P);

end

