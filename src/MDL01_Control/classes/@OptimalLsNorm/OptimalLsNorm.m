classdef OptimalLsNorm < AbstractOptimalControl
    %OPTIMALLSNORM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Target  = []
        s       =  2
        sp      =  2
        kappa   =  1
    end
    
    methods
        function obj = OptimalLsNorm(Dynamics)

            if ~Dynamics.lineal
               error('No lineal dynamics no implemented') 
            end
            
            obj.Dynamics = copy(Dynamics);
            
            obj.Target  = zeros(length(obj.Dynamics.StateVector.Symbolic),1);

            %% Adjoint 
            obj.Adjoint.Dynamics = pde('A',Dynamics.A);
            obj.Adjoint.Dynamics.Nt = Dynamics.Nt;
            obj.Adjoint.Dynamics.mesh = Dynamics.mesh;
        end
        
    end
end

