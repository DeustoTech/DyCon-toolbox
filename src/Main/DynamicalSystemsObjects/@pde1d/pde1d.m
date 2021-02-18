classdef pde1d < ode
    %PDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xline double
        
    end
    
    methods
        function obj = pde1d(DynamicFcn,ts,State,Control,tspan,xline,varargin)
            %ODE Continuous dynamical systems
            obj = obj@ode(DynamicFcn,ts,State,Control,tspan,varargin{:});
            obj.xline = xline;
            % Default 
        end
        
    end
end

