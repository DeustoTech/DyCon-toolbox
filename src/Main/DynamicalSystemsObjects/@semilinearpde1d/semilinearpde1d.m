classdef semilinearpde1d < pde1d
    %LINEARPDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A               double
        B               double
        NonLinearTerm   casadi.Function
        GradientNLT     casadi.Function
    end
    
    methods
        function obj = semilinearpde1d(State,Control,A,B,NonLinearTerm,tspan,mesh)
            %LINEARPDE1D Construct an instance of this class
            %   Detailed explanation goes here
            
            import casadi.*
            ts = SX.sym('t');
            DynamicFcn = Function('f',{ts,State,Control},{ A*State + B*Control + NonLinearTerm(State) });

            obj@pde1d(DynamicFcn,State,Control,tspan,mesh)
            
            NLT = NonLinearTerm(State);
            n   = length(State);
            GradCell  = arrayfun(@(i) gradient(NLT(i),State(i)),1:n,'UniformOutput',false);
            
            obj.GradientNLT = casadi.Function('GradNLT',{State},{[GradCell{:}]'});

            obj.NonLinearTerm = NonLinearTerm;
            obj.A = A;
            obj.B = B;
            %
            SetIntegrator(obj,'SemiLinearFordwardEuler')

%            obj.solver = @Domenec;
            
        end
        
    end
end

