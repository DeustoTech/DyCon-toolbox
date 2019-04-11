classdef InverseProblem < handle
    %INVERSEPROBLEM Summary of this clas    s goes here
    %   Detailed explanation goes here
    
    properties
        functional
        dynamics
        adjoint
        gradient
        FinalState
        solution
        constraints constraints = constraints
    end
    
    methods
        function obj = InverseProblem(dynamics,FinalState)
            
            obj.dynamics            	= copy(dynamics);
            obj.adjoint.dynamics        = copy(dynamics);
            obj.FinalState              = FinalState;
            obj.adjoint.FinalCondition  = @(Y) (Y-obj.FinalState) ;

                
        end

    end
end

