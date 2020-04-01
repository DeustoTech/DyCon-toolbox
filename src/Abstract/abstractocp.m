classdef (Abstract) abstractocp 
    %ABSTRACTOCP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CostFcn          CostFcn
        VariableTime     logical = false
        contraints       constraints = constraints
    end
    
    properties ( Hidden = false)
        Hamiltonian             casadi.Function  
        AdjointStruct           AdjointStruct = AdjointStruct
        ControlGradient         casadi.Function
    end
    methods

    end
end

