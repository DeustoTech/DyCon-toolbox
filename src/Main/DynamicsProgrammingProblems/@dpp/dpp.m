classdef dpp < handle
    %DPP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DynamicSystem
        CostFcn          CostFcn
    end
    
    methods
        function obj = dpp(DynamicSystem,PathCostFcn,FinalCostFcn)
            %DPP Construct an instance of this class
            %   Detailed explanation goes here
            obj.DynamicSystem   =  copy(DynamicSystem);
            obj.CostFcn         =  CostFcn(PathCostFcn,FinalCostFcn);
        end

    end
end

