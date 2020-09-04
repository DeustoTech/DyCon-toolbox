classdef linearode < ode 
    %LINEARODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A double
        B double
        C double
        D double
    end
    
    methods
        function obj = linearode(A,B,tspan)
            % LINEARODE

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% VALIDATIONS SECTION 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [DynamicFcn,x,u] = Matrixs2CasFun(A,B);

            obj@ode(DynamicFcn,x,u,tspan)
            
            obj.A = A;
            obj.B = B;
            % By Default

            dt = tspan(2) - tspan(1);
            M = eye(obj.StateDimension);
            N = obj.StateDimension;
            %
            obj.C = speye(N,N)-dt*A;
            obj.C = inv(obj.C);
            
            obj.D = obj.C*(dt*B);

            SetIntegrator(obj,'LinearBackwardEuler')
            
        end
        
    end
end

