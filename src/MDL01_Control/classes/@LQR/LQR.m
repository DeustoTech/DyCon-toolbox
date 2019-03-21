classdef LQR < OptimalControl
    %LQR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        epsilon
        YT    
    end
    
    methods
        function obj = LQR(A,B,mesh,varargin)
            
            p = inputParser;
            
            addRequired(p,'A')
            addRequired(p,'B')
            addRequired(p,'mesh')

            addOptional(p,'YT', zeros(length(A(:,1)),1))
            addOptional(p,'epsilon', 0.01)
            parse(p,A,B,mesh,varargin{:})
            
            
            dx = mesh(2) -mesh(1);
            
            %%
            YT   = p.Results.YT;
            epsilon = p.Results.epsilon;
            
            dynamics = ode('A',A,'B',B);
            
            Y = dynamics.StateVector.Symbolic;
            U = dynamics.Control.Symbolic;

            symPsi  = dx/(2*epsilon)*(YT - Y).'*(YT - Y);
            symL    = dx/2*(U.'*U);
            obj@OptimalControl(dynamics,symPsi,symL);
            
            obj.YT = YT;
            obj.epsilon = epsilon;
        end
        
    end
end

