classdef semilinearpde1d < pde1d
    %LINEARPDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A               double
        B               double
        C
        D
        NonLinearTerm   casadi.Function
        GradientNLT     casadi.Function
    end
    
    methods
        function obj = semilinearpde1d(ts,State,Control,A,B,NLT,tspan,mesh)
            %LINEARPDE1D Construct an instance of this class
            %   Detailed explanation goes here
            
            import casadi.*
            
            NonLinearTerm = casadi.Function('GradNLT',{ts,State,Control},{NLT});
            
            DynamicFcn =  A*State + B*Control + NLT ;

            obj@pde1d(DynamicFcn,ts,State,Control,tspan,mesh)
                        
            obj.GradientNLT = casadi.Function('GradNLT',{ts,State,Control},{jacobian(NLT,State)});

            obj.NonLinearTerm = NonLinearTerm;
            obj.A = A;
            obj.B = B;
            %
            SetIntegrator(obj,'OperatorSplitting')
            
        end
        
    end
end

