function P = GetNumericalAdjoint(iCP,U,Y)

        T = iCP.dynamics.FinalTime;
        iCP.adjoint.dynamics.InitialCondition = iCP.adjoint.FinalCondition.Numeric(T,Y(end,:)');

        iCP.adjoint.dynamics.dt = iCP.dynamics.dt;
        iCP.adjoint.dynamics.FinalTime = iCP.dynamics.FinalTime;
        iCP.adjoint.dynamics.SolverParameters = iCP.dynamics.SolverParameters;
        iCP.adjoint.dynamics.MassMatrix = iCP.dynamics.MassMatrix;
        iCP.adjoint.dynamics.Solver = iCP.dynamics.Solver;
        
        if iCP.adjoint.dynamics.lineal
            [~,P] = solve(iCP.adjoint.dynamics);
        else
            Control = [Y U];
            Control = flipud(Control);
            [~,P] = solve(iCP.adjoint.dynamics,'Control',Control);
        end
        P = flipud(P);

end

