function P = GetNumericalAdjoint(iCP,U,Y)

        T = iCP.Dynamics.FinalTime;
        iCP.Adjoint.Dynamics.InitialCondition = iCP.Adjoint.FinalCondition.Numeric(T,Y(end,:)');

        iCP.Adjoint.Dynamics.dt = iCP.Dynamics.dt;
        iCP.Adjoint.Dynamics.FinalTime = iCP.Dynamics.FinalTime;
        iCP.Adjoint.Dynamics.SolverParameters = iCP.Dynamics.SolverParameters;
        iCP.Adjoint.Dynamics.MassMatrix = iCP.Dynamics.MassMatrix;
        iCP.Adjoint.Dynamics.Solver = iCP.Dynamics.Solver;
        
        if iCP.Adjoint.Dynamics.lineal
            [~,P] = solve(iCP.Adjoint.Dynamics);
        else
            Control = [Y U];
            Control = flipud(Control);
            [~,P] = solve(iCP.Adjoint.Dynamics,'Control',Control);
        end
        P = flipud(P);

end

