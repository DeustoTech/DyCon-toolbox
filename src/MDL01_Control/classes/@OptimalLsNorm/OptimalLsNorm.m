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
        function obj = OptimalLsNorm(dynamics)

            if ~dynamics.lineal
               error('No lineal dynamics no implemented') 
            end
            
            obj.dynamics = dynamics;
            
            Target  = zeros(length(obj.dynamics.StateVector.Symbolic),1);

            
        end
        
    end
end

