function [dU,J,Xsol] = Control2ControlGradient(iocp,Control)
%CONTROL2CONTROLGRADIENT Summary of this function goes here
%   Detailed explanation goes here
    %% Take tools 
    Xsystem = iocp.DynamicSystem;
    Psystem = iocp.AdjointStruct.DynamicSystem;
    tspan   = Xsystem.tspan;

    FinalConditionAdjointFcn = iocp.AdjointStruct.FinalCondition;
    ControlGradient          = iocp.ControlGradient;
    Cost = iocp.CostFcn;

    %%
    Xsol = devsolve(Xsystem,Control);

    % take final state with this control
    XT    = Xsol(:,end);
    % with this Final Condition, we can calculate the FinalCondition of
    % Adjoint Problem
    PT = FinalConditionAdjointFcn(XT);
    % Now, we can solve the Adjoint problem
    Psystem.InitialCondition = PT;
    Psol = devsolve(Psystem,[fliplr(Xsol);fliplr(Control)]);
    Psol = fliplr(Psol);
    % ConpControle Control Gradient
    dU = ControlGradient(tspan,Xsol,Control,Psol);
    %
    L_t = Cost.PathCostFcn(tspan,Xsol,Control);

    Psi = Cost.FinalCostFcn(XT);
    L_t_sum = 0.5*sum(diff(tspan).*(L_t(1:end-1)+L_t(2:end)));
    J =  L_t_sum + Psi;
 
end

