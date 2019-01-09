classdef ControlParameterDependent < handle & matlab.mixin.Copyable
% description: ANA Cambio - The Average Control class is able to calculate the average control given the matrices
% that depend on the parameter. It has as parameter the state where you want to take all 
% the equations that depend on the parameters.    
% visible: true
    properties
        % type: "Numeric value"
        % default: "none"
        % description: "Number of states of the system"
        N   
        % type: "Matrix"
        % default: "none"
        % description: $N\\times N$ matrix governing the free dynamics of the system
        A   
        % type: "Matrix"
        % default: "none"
        % description: $N\\times M$ matrix. Control operator
        B         
        % type: "Vector"
        % default: "none"
        % description: "Vector with the initial states"
        x0        
        % type: "Vector"
        % default: "none"
        % description: "Vector dimension initial value of the control"
        u0        
        % type: "Vector"
        % default: "none"
        % description: "Vector of time"
        span        
        % type: "Numerical value"
        % default: "none"
        % description: Length of the parameter $\\nu$
        K  
        % type: "Numerical value"
        % default: "none"
        % description: "Aditional data of gradient methods. You can find the history "
        addata
        % type: "Numerical value"
        % default: "none"
        % description: "Control Obtain"
        u                    

    end
    

    
    
    methods
        function obj = ControlParameterDependent(A,B,x0,u0,span)
        % name: ControlParameterDependent
        % description: ControlParameterDependent constructor
        % autor: JOroya
        % MandatoryInputs:   
        %   iode: 
        %       name: Ordinary Differential Equation 
        %       description: Ordinary Differential Equation represent the
        %           constrain to minimize the functional. It is a finite
        %           dimensional parameter-dependent linear system of ordinary
        %           differential equations."
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
        %       description: "This parameter represent is the interval to interpolate the control u and state y to obtain the functional"
        %       class: double
        %       dimension: [1x1]
        %       default: iode.dt 
        % Outputs:
        %   obj:
        %       name: Control Prameter Dependent
        %       description: Control Prameter Dependent Class
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

