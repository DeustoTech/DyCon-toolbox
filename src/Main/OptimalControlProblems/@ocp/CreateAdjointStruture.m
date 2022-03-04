function CreateAdjointStruture(iocp)
%CREATEADJOINTSTRUTURE Summary of this function goes here
%   Detailed explanation goes here
        DynSys = iocp.DynamicSystem;
        %
        [ts,Xs,Us] = symvars(DynSys);
        %
        Ps = casadi.SX.sym('p_adjoint',size(Xs));
        %%
        F_x   = iocp.DynamicSystem.Jacobians.State;
        Psi_x = iocp.CostFcn.FinalCostGradients.State;
        Lag_x = iocp.CostFcn.PathCostGradients.State;
        %% Compute Adjoint Problem
        XUs = [Xs;Us];
        Nx = DynSys.StateDimension;
        %
        % Create the dynamical function of adjoint, 
        % \dot{P} = -H_x and
        %  P(T)   = \Psi_x
        %
        % So, Hx = (F_x)'*P +L_x
        %
        Hx = F_x(ts,XUs(1:Nx),XUs(Nx+1:end))'*Ps + Lag_x(ts,Xs,Us);
        %    
        classDynamics = class(DynSys);
        
        X0p = rand + ZerosInitialCondition(DynSys);
        U0p = rand + zeros(DynSys.ControlDimension,1);
        Lag_value = full(sum(Lag_x(rand,X0p,U0p)));
        
       
        n = DynSys.StateDimension;
        m = DynSys.ControlDimension;
        
        switch classDynamics
            case 'ode'
                iocp.AdjointStruct.DynamicSystem  = ode(Hx,ts,Ps,XUs,DynSys.tspan);
            case 'linearode'
                if  Lag_value == 0
                    A = DynSys.A;
                    B     = zeros(n,m+n);
                    iocp.AdjointStruct.DynamicSystem  = linearode(A,B,ts,DynSys.tspan);
                else
                    iocp.AdjointStruct.DynamicSystem  = ode(Hx,ts,Ps,XUs,DynSys.tspan);
                end
            case 'pde1d'
                mesh  = DynSys.xline;
                iocp.AdjointStruct.DynamicSystem  = pde1d(Hx,ts,Ps,XUs,DynSys.tspan,mesh);
            case 'pde2d'
                xline  = DynSys.xline;
                yline  = DynSys.yline;
                iocp.AdjointStruct.DynamicSystem  = pde2d(Hx,ts,Ps,XUs,DynSys.tspan,xline,yline);                
            case 'linearpde1d'
                mesh  = DynSys.xline;
                if  Lag_value == 0
                    A     = DynSys.A;
                    B     = zeros(n,m+n);
                    iocp.AdjointStruct.DynamicSystem  = linearpde1d(A,B,ts,DynSys.tspan,mesh);
                else
                    iocp.AdjointStruct.DynamicSystem  = pde1d(Hx,ts,Ps,XUs,DynSys.tspan,mesh);
                end
            case 'pdefem'
                Nodes = DynSys.Nodes;
                Elements = DynSys.Elements;
                iocp.AdjointStruct.DynamicSystem  = pdefem(Hx,Ps,XUs,DynSys.tspan,Nodes,Elements);                

        end
        
        %
        % Copy all properties from primal dynamical system to adjoint
        % system
        %
        CopySystemProperties(iocp.AdjointStruct,DynSys);

        switch class(iocp.AdjointStruct.DynamicSystem)
            case {'ode','pde1d','pde2d','pdefem'}
                SetIntegrator(iocp.AdjointStruct.DynamicSystem,'RK4')
            otherwise
                
        end
        %
        % Save the gradient of Final Cost in Adjoint Structure
        %
        iocp.AdjointStruct.FinalCondition = Psi_x;
            
    
end

