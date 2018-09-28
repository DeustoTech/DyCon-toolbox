classdef ode < handle
    %ode % dx/dt = A*x + B*u(x)
    
    
    properties
        % Definition of differential equation 
        A   = 1             % Linear square matrix 
        B                % Matrix of control
        % 
        u                   % Function control 
        %
        x0                  % Initial state
        x                   % Solution 
        span                % [t0 T0]
        xend                % Last vector state 
        
    end
    
    methods
        function obj = ode(A,varargin)
           
            if nargin == 0
                return
            end
            
            p = inputParser;
            addRequired(p,'A')
            addOptional(p,'B',[])
            
            parse(p,A,varargin{:})
            
            obj.B = p.Results.B;
            obj.A = A; 
        end
        
        function obj = solve(obj)
            
            for iedo = obj
                
                if isempty(iedo.B)||isempty(iedo.u)
                    ecuation = @(t, x) iedo.A*x;
                else
                    ecuation = @(t, x) iedo.A*x + iedo.B*interp1(iedo.span,iedo.u, t);
                end
                                
                [~, iedo.x] = ode45(ecuation,iedo.span, iedo.x0);
                iedo.xend = iedo.x(end,:);
            end
        end
        
        
        
    end
    %%
    methods (Static)
        function z = zeros(varargin)
          %% Zeros constructor 
             if (nargin == 0)
                z = ode;
             elseif any([varargin{:}] <= 0)
             % For zeros with any dimension <= 0   
                z = ode.empty(varargin{:});
             else
             % Use property default values
                z = repmat(ode,varargin{:});
             end
        end
    end
end

