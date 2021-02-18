classdef CostFcn < handle
    %COSTFCN is a structure where save the functions handles of total cost.
    
    
    properties
        PathCostFcn      casadi.Function
        FinalCostFcn     casadi.Function
        FinalCostGradients FinalCostGradients = FinalCostGradients
        PathCostGradients  PathCostGradients = PathCostGradients
    end
    
    methods
        function obj = CostFcn(PathCostFcn,FinalCostFcn,Dyn)
            %COSTFCN 
            %
            [ts,Ys,Us] = symvars(Dyn);
            %
            obj.PathCostFcn  = casadi.Function('L',{ts,Ys,Us},{PathCostFcn});
            obj.FinalCostFcn = casadi.Function('Psi',{Ys},{FinalCostFcn});    
                      
        end
        

    end
end

