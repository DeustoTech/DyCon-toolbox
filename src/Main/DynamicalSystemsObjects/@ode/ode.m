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
    
    properties (Hidden)
        HasSolver = false
    end
    methods
        function obj = ode(DynamicFcn,ts,State,Control,tspan,varargin)
            %ODE Continuous dynamical systems
            
            %ts     = casadi.SX.sym('ts');
            if isa(DynamicFcn,'casadi.Function')
                DynamicFcn = DynamicFcn(ts,State,Control);
            end
            %%
            obj = obj@dtsys(DynamicFcn,State,Control,ts,varargin{:});
            

            N = length(obj.State.sym);
            obj.MassMatrix = eye(N);
            obj.tspan = tspan;
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

