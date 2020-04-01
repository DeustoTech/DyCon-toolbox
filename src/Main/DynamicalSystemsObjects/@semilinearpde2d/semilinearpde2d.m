classdef semilinearpde2d < semilinearpde1d
    %LINEARPDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A               double
        B               double
        NonLinearTerm   casadi.Function
        GradientNLT     casadi.Function
    end
    
    methods
        function obj = semilinearpde2d(State,Control,A,B,NonLinearTerm,tspan,mesh)
            %LINEARPDE1D Construct an instance of this class
            %   Detailed explanation goes here
            
            import casadi.*

            obj@semilinearpde1d(State,Control,A,B,NonLinearTerm,tspan,mesh)
            
            
        end
        
    end
end

