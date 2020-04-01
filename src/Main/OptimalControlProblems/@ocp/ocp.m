classdef ocp < handle
%
% OCP Optimal Control Problem 
% ------------------------------
% min_{x,u} J(x,u) = min_{x,u} \Phi(x(T)) + \int_0^T L(x(t),u(t),t) dt 
%    
    properties
        DynamicSystem
        CostFcn          CostFcn
        VariableTime     logical     = false
        constraints       constraints = constraints
        TargetState      double
    end
    
    properties ( Hidden = false)
        Hamiltonian             casadi.Function  
        AdjointStruct           AdjointStruct = AdjointStruct
        ControlGradient         casadi.Function
    end
    
    methods
        function obj = ocp(DynamicSystem,PathCostFcn,FinalCostFcn,varargin)
            %
            % OCP Optimal Control Problem 
            % ------------------------------
            % min_{x,u} J(x,u) = min_{x,u} \Phi(x(T)) + \int_0^T L(x(t),u(t),t) dt 
            % s.t
            %       x_t = f(x,u,t)
            %       x(0) = x_0
            %%
            p = inputParser;
            addRequired(p,'idynamics'   );
            %
            addRequired(p,'PathCostFcn' );
            addRequired(p,'FinalCostFcn');
            %
            addOptional(p,'SymCalculations',true)

            parse(p,DynamicSystem,PathCostFcn,FinalCostFcn,varargin{:})
            %%
            obj.DynamicSystem   =  copy(DynamicSystem);
            obj.CostFcn         =  CostFcn(PathCostFcn,FinalCostFcn);
            %
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
            ts = DynSys.ts;
            Xs = DynSys.State.sym;
            Us = DynSys.Control.sym;
            %% Compute Adjoint Problem           
            CreateAdjointStruture(obj)
            
            %% Compute Control Gradient as Symbolical Function
            Ps = obj.AdjointStruct.DynamicSystem.State.sym;

            obj.ControlGradient = casadi.Function('Hu',{ts,Xs,Us,Ps},{F_u(ts,Xs,Us)'*Ps + Lag_u(ts,Xs,Us)});
            %
            obj.constraints = constraints;
            %          
        end
        %%
        %% SETTERS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set.DynamicSystem(obj,Dynamics)
            %
            % validations
            mustBeMember(class(Dynamics),{'linearode','ode','pde1d','pde2d','linearpde1d','semilinearpde1d','pdefem'})
            %
            % set
            obj.DynamicSystem = Dynamics;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set.TargetState(obj,TargetState)
           [n,m] = size(TargetState);
           if m ~= 1
              error('Target must be a column')
           elseif n ~= obj.DynamicSystem.StateDimension
              error('The Target property must have the same dimension of vector state')
           end
           obj.TargetState = TargetState;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end
end

