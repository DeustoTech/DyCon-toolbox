classdef LQR < AbstractOptimalControl
    %LQR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FunctionalParams      LQRFunctional = LQRFunctional
    end
    
    methods
        function obj = LQR(dynamics)
            
            obj.Dynamics = dynamics;
        end
        
    end
end

