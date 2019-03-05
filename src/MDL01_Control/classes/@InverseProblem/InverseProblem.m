classdef InverseProblem < handle
    %INVERSEPROBLEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FinalState
        dynamics 
        adjoint
    end
    
    methods
        function obj = InverseProblem(A,FinalState)
            
                obj.dynamics = ode('A',A);
                obj.adjoint.dynamics  = ode('A',A);
                obj.adjoint.FinalCondition = @(Y) (Y-FinalState);
                obj.FinalState = FinalState;
                
        end

    end
end

