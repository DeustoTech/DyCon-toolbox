function ComputeCostGradients(iocp)

    ts = casadi.SX.sym('t');
    Xs = iocp.DynamicSystem.State.sym;
    Us = iocp.DynamicSystem.Control.sym;

    % L   = PathCost
    % Psi = TerminalCost

    iocp.CostFcn.PathCostGradients.State   = casadi.Function('Lx',{ts,Xs,Us},{gradient(iocp.CostFcn.PathCostFcn(ts,Xs,Us),Xs)});

    iocp.CostFcn.PathCostGradients.Control = casadi.Function('Lu',{ts,Xs,Us},{gradient(iocp.CostFcn.PathCostFcn(ts,Xs,Us),Us)});

    iocp.CostFcn.FinalCostGradients.State = casadi.Function('Psix',{Xs},{gradient(iocp.CostFcn.FinalCostFcn(Xs),Xs)});

end

