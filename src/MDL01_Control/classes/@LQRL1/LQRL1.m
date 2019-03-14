classdef LQR1 < OptimalControl
    %LQR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        epsilon
        YT    
    end
    
    methods
        function obj = LQR1(A,B,varargin)
            
            p = inputParser;
            
            addRequired(p,'A')
            addRequired(p,'B')
            
            addOptional(p,'YT', zeros(length(A(:,1)),1))
            addOptional(p,'epsilon', 0.01)
            parse(p,A,B,varargin{:})
            
            
            
            %%
            YT   = p.Results.YT;
            epsilon = p.Results.epsilon;
            
            dynamics = ode('A',A,'B',B);
            
            Y = dynamics.StateVector.Symbolic;
            U = dynamics.Control.Symbolic;

            symPsi  = 1/(2*epsilon)*(YT - Y).'*(YT - Y);
            symL    = 1/2*(U.'*U);
            obj@OptimalControl(dynamics,symPsi,symL);
            
            obj.YT = YT;
            obj.epsilon = epsilon;
        end
        
    end
end

