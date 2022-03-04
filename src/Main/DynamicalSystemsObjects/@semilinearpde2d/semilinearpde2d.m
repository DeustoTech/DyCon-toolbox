classdef semilinearpde2d < pde2d
    %LINEARpde2d Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A               double
        B               double
        C               double
        D               double
        NonLinearTerm   
        GradientNLT    
    end
    
    methods
        function obj = semilinearpde2d(ts,State,Control,A,B,NonLinearTerm,tspan,xline,yline)
            %LINEARpde2d Construct an instance of this class
            %   Detailed explanation goes here
            
            import casadi.*
            DynamicFcn =  A*State + B*Control + NonLinearTerm;

            obj@pde2d(DynamicFcn,ts,State,Control,tspan,xline,yline)
            
            ts = obj.ts;
            
            NLT = NonLinearTerm;
            n   = length(State);
            GradCell  = arrayfun(@(i) gradient(NLT(i),State(i)),1:n,'UniformOutput',false);
            
            obj.GradientNLT = casadi.Function('GradNLT',{ts,State,Control},{[GradCell{:}]'});

            obj.NonLinearTerm = NonLinearTerm;
            obj.A = A;
            obj.B = B;
            %
            
        end
        
    end
end

