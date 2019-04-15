classdef InverseProblem < handle
    %INVERSEPROBLEM Summary of this clas    s goes here
    %   Detailed explanation goes here
    
    properties
        gamma  = 1e-3
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
            
            dx = dynamics.mesh(2) - dynamics.mesh(1);
            obj.adjoint.FinalCondition  = @(Y) dx*(Y-obj.FinalState) ;
                
        end

    end
end

