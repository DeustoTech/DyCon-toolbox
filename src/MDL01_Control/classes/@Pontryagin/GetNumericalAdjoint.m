function P = GetNumericalAdjoint(iCP,U,Y)

        T = iCP.Dynamics.FinalTime;
        iCP.Adjoint.Dynamics.InitialCondition = iCP.Adjoint.FinalCondition.Numeric(T,Y(end,:).').';

        iCP.Adjoint.Dynamics.Nt = iCP.Dynamics.Nt;
        iCP.Adjoint.Dynamics.FinalTime = iCP.Dynamics.FinalTime;
        iCP.Adjoint.Dynamics.MassMatrix = iCP.Dynamics.MassMatrix;
        iCP.Adjoint.Dynamics.FixedNt = true;
        if iCP.Adjoint.Dynamics.lineal
            [~,P] = solve(iCP.Adjoint.Dynamics);
        else
            NtControl    = length(U(:,1));
            tspan        = iCP.Dynamics.tspan;
            tspanControl = linspace(tspan(1),tspan(end),NtControl);
            U = interp1(tspanControl',U,tspan');
            Control = [Y U];
            Control = flipud(Control);
            [~,P] = solve(iCP.Adjoint.Dynamics,'Control',Control);
        end
        P = flipud(P);

end

