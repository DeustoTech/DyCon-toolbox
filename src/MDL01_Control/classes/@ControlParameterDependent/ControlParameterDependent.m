classdef ControlParameterDependent < handle & matlab.mixin.Copyable
% description: The goal of this class is to solve optimal control problems where the states are defined via 
%               finite dimensional parameter-dependent systems of the form 
%               $$\\dot{x}(t,\\nu)=A(\\nu)x(t,\\nu)+B(\\nu)u(t), \\, t>T, \\quad x(0)=x0,$$ 
%               being $\\nu$ the parameter that can be discrete or continuous. 
%               Different iterative algorithms based on gradient descent methods are performed 
%               to reach this objective. For example, the classical gradient descent technique or stochastic 
%               gradient descent method, which has become important in the last years.   
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

