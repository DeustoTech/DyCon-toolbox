function ComputeCostGradients(iocp)


    [ts,Xs,Us] = symvars(iocp.DynamicSystem);

    iocp.CostFcn.PathCostGradients.State   = casadi.Function('Lx',{ts,Xs,Us},{gradient(iocp.CostFcn.PathCostFcn(ts,Xs,Us),Xs)});

    iocp.CostFcn.PathCostGradients.Control = casadi.Function('Lu',{ts,Xs,Us},{gradient(iocp.CostFcn.PathCostFcn(ts,Xs,Us),Us)});

    iocp.CostFcn.FinalCostGradients.State = casadi.Function('Psix',{Xs},{gradient(iocp.CostFcn.FinalCostFcn(Xs),Xs)});

end

