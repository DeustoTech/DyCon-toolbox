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
        Constraints      constraints 
        TargetState      double
    end
    
    properties ( Hidden = false)
        Hamiltonian             casadi.Function  
        AdjointStruct           AdjointStruct = AdjointStruct
        ControlGradient         casadi.Function
        HasGradients            logical = false;
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
            addRequired(p,'PathCostFcn' ,@checkPathCost);
            addRequired(p,'FinalCostFcn',@checkFinalCost);
            %
            addOptional(p,'EqualityEndConstraint',[]);
            addOptional(p,'EqualityPathConstraint',[]);
            addOptional(p,'InequalityEndConstraint',[]);
            addOptional(p,'InequalityPathConstraint',[]);
            %

            parse(p,DynamicSystem,PathCostFcn,FinalCostFcn,varargin{:})
            %%
            if isa(PathCostFcn,'casadi.Function')
                PathCostFcn = PathCostFcn(ts,State,Control);
            end
            if isa(FinalCostFcn,'casadi.Function')
                FinalCostFcn = FinalCostFcn(State);
            end
            %%
            obj.DynamicSystem   =  copy(DynamicSystem);
            obj.CostFcn         =  CostFcn(PathCostFcn,FinalCostFcn,obj.DynamicSystem);
            %
            Equa_End  = p.Results.EqualityEndConstraint;
            Equa_Path = p.Results.EqualityPathConstraint;
            Ineq_End  = p.Results.InequalityEndConstraint;
            Ineq_Path = p.Results.InequalityPathConstraint;
            %
            %
            obj.Constraints = constraints(Equa_End      , ...
                                          Equa_Path     , ...
                                          Ineq_End      , ...
                                          Ineq_Path     , ...
                                          obj.DynamicSystem);
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


function checkPathCost(x)
    if ~( isa(x,'casadi.SX') || isa(x,'casadi.Function') || isnumeric(x))
       error('The PathCostFcn must be a casadi.SX obj') 
    end
end
function checkFinalCost(x)
    if ~( isa(x,'casadi.SX') || isa(x,'casadi.Function') || isnumeric(x))
       error('The FinalCostFcn must be a casadi.SX obj') 
    end
end