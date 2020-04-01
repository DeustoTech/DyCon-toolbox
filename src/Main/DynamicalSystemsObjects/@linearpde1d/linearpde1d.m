classdef linearpde1d < pde1d
    %LINEARPDE1D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A double
        B double
        C double
        D double

    end
    
    methods
        function obj = linearpde1d(A,B,tspan,mesh)
            %LINEARPDE1D Construct an instance of this class
            %   Detailed explanation goes here
            [DynamicFcn,x,u] = Matrixs2CasFun(A,B);
            obj@pde1d(DynamicFcn,x,u,tspan,mesh)
            
            obj.A = A;
            obj.B = B;
            
            dt = tspan(2) - tspan(1);
            M = obj.MassMatrix;
            N = obj.StateDimension;
            %
            obj.C = speye(N,N)-dt*(M\A);
            obj.C = inv(obj.C);
            
            obj.D = obj.C*(dt*(M\B));

            SetIntegrator(obj,'LinearFordwardEuler')
        end
        
        
        
        

    end
end

