classdef InverseProblem < AbstractOptimalControl
    %INVERSEPROBLEM Summary of this clas    s goes here
    %   Detailed explanation goes here
    
    properties
        gamma  = 1e-3
        FinalState
    end
    
    methods
        function obj = InverseProblem(Dynamics,FinalState)
            
            obj.Dynamics            	= copy(Dynamics);
            obj.Adjoint.dynamics        = copy(Dynamics);
            obj.FinalState              = FinalState;
            
            obj.Adjoint.FinalCondition  = @(Y) (Y-obj.FinalState) ;
                
        end

    end
end

