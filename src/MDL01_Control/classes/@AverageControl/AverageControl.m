classdef AverageControl < handle & matlab.mixin.Copyable
% The Average Control class is able to calculate the average control given the matrices
% that depend on the parameter. It has as parameter the state where you want to take all 
% the equations that depend on the parameters.    
    properties
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        A   
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        B         
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        x0        
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        u0        
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        span        
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        K         
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        N   
        addata      % aditional data

    end
    
    properties (Hidden)
        u                   % control 
    end
    
    
    methods
        function obj = AverageControl(A,B,x0,u0,span)
        % name: AverageControl
        % description: AverageControl constructor
        % autor: JOroya
        % MandatoryInputs:   
        %   iode: 
        %       name: Ordinary Differential Equation 
        %       description: Ordinary Differential Equation represent the constrain to minimization the functional 
        %       class: ode
        %       dimension: [1x1]
        %   Jfun: 
        %       name: functional
        %       description: Cost function to obtain the optimal control 
        %       class: Functional
        %       dimension: [1x1]        
        % OptionalInputs:
        %   T:
        %       name: Final Time 
        %       description: This parameter represent the final time of simulation.  
        %       class: double
        %       dimension: [1x1]
        %       default: iode.T 
        %   dt:
        %       name: Final Time 
        %       description: "This parameter represent is the interval to interpolate the control u and state y to obtain the functional
        %       class: double
        %       dimension: [1x1]
        %       default: iode.dt 
            obj.A    = A;
            obj.B    = B;
            obj.x0   = x0;
            obj.u0   = u0;
            obj.span = span;
            %
            [~ ,obj.N ,obj.K] = size(obj.A);         
        end
        
    end
end

