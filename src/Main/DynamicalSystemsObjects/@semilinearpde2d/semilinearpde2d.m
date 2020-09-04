classdef semilinearpde2d < pde2d
    %LINEARpde2d Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A               double
        B               double
        C               double
        D               double
        NonLinearTerm   casadi.Function
        GradientNLT     casadi.Function
    end
    
    methods
        function obj = semilinearpde2d(State,Control,A,B,NonLinearTerm,tspan,xline,yline)
            %LINEARpde2d Construct an instance of this class
            %   Detailed explanation goes here
            
            import casadi.*
            ts = SX.sym('t');
            DynamicFcn = Function('f',{ts,State,Control},{ A*State + B*Control + NonLinearTerm(ts,State,Control) });

            obj@pde2d(DynamicFcn,State,Control,tspan,xline,yline)
            
            NLT = NonLinearTerm(ts,State,Control);
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

