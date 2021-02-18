function PreIndirectMethod(obj)
    DynSys = obj.DynamicSystem;

    %% Compute Gradient and Jacobians
    ComputeJacobians(obj.DynamicSystem)
    %
    ComputeCostGradients(obj)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Lag_u = obj.CostFcn.PathCostGradients.Control;
    %
    F_u   = obj.DynamicSystem.Jacobians.Control;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Obtain Symbolical Variables
    [ts,Xs,Us] = symvars(DynSys);
    %% Compute Adjoint Problem           
    CreateAdjointStruture(obj)

    %% Compute Control Gradient as Symbolical Function
    Ps = obj.AdjointStruct.DynamicSystem.State.sym;

    obj.ControlGradient = casadi.Function('Hu',{ts,Xs,Us,Ps},{F_u(ts,Xs,Us)'*Ps + Lag_u(ts,Xs,Us)});
    %
    %      
    obj.HasGradients = true;       
end

