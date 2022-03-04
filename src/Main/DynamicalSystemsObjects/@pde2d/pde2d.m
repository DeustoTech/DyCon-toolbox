classdef pde2d < ode
    %PDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xline double
        yline double
        xms   double
        yms   double
    end
    
    methods
        function obj = pde2d(DynamicFcn,ts,State,Control,tspan,xline,yline,varargin)
            %ODE Continuous dynamical systems
            obj = obj@ode(DynamicFcn,ts,State,Control,tspan,varargin{:});
            obj.xline = xline;
            obj.yline = yline;
            [obj.xms,obj.yms] = meshgrid(xline,yline);
            % Default 
        end
        
    end
end

