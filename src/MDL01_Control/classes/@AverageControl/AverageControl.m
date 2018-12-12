classdef AverageControl < handle & matlab.mixin.Copyable
    %AVERAGECONTROL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A         % A(:,:,K) with K number of parameter
        B         % B(:,:,K) with K number of parameter
        x0        % initial state of all ode's
        %
        u0        % Initial control, must have same dimesion of span
        span      % Time line [t0 : dt : T],  
        K         % length of parameters list
        N         % dimesion of vector state
    end
    
    properties (Hidden)
        u                   % control 
        addata      % aditional data
    end
    
    
    methods
        function obj = AverageControl(A,B,x0,u0,span)
            %AVERAGECONTROL Construct an instance of this class
            %   Detailed explanation goes here
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

