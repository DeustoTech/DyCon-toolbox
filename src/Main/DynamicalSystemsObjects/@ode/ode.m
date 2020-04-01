classdef ode < dtsys
    %ODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tspan double
        ts    casadi.SX
        MassMatrix 
        method
        solver %casadi.Function
    end
    
    methods
        function obj = ode(DynamicFcn,State,Control,tspan,varargin)
            %ODE Continuous dynamical systems
            obj = obj@dtsys(DynamicFcn,State,Control,varargin{:});
            obj.tspan = tspan;
            
            obj.ts    = casadi.SX.sym('t');
            
            N = length(obj.State.sym);
            obj.MassMatrix = eye(N);

        end
        
        function set.solver(obj,solver)
            
            obj.solver = solver;
        end
        
        function set.tspan(obj,tspan)
            obj.tspan = tspan;
            obj.Nt    = length(tspan);
        end

    end
end

