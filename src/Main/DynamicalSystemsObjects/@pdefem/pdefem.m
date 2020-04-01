classdef pdefem < ode
    %PDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nodes
        Elements
    end
    
    methods
        function obj = pdefem(DynamicFcn,State,Control,tspan,Nodes,Elements,varargin)
            %ODE Continuous dynamical systems
            obj = obj@ode(DynamicFcn,State,Control,tspan,varargin{:});
            obj.Nodes = Nodes;
            obj.Elements = Elements;
            % Default 
        end
        
    end
end

