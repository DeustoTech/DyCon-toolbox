classdef AdjointStruct < handle
    %ADJOINTSTRUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DynamicSystem 
        FinalCondition casadi.Function
    end
    
    methods
        function set.DynamicSystem(obj,Dynamics)
            %
            % validations
            mustBeMember(class(Dynamics),{'linearode','ode','pde1d','linearpde1d','semilinearpde1d','pde2d','pdefem'})
            %
            % set
            obj.DynamicSystem = Dynamics;
        end
        

    end
end

