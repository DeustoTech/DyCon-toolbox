classdef ode < handle & matlab.mixin.Copyable
    %ODE 
    %% Show by console
    properties
    % ------------------------------------------------------------------------------------------------ %%
    %   Name     | Dimension  |    Type            |   Description                                     %%
    % ------------------------------------------------------------------------------------------------ %%
    
        numF                    function_handle     % Numeric derivative  dy/dt = F(t,y,u)             %%
    
    % ------------------------------------------------------------------------------------------------ %%
    
        symF                    sym                 % Symbolic dy/dt = F(t,y,u)                        %%
    
    % ------------------------------------------------------------------------------------------------ %%
    
        Y0                      double              % Initial State Y = [y1(0) y2(0) y3(0) ...]^T      %%
    
    % ------------------------------------------------------------------------------------------------ %%
    
        Y                       double              % Numerical Solution Y = [y1(t0) y2(t0) y3(t0)     %%
                                                    %                         y1(t1) y2(t1) y3(t1)     %%  
                                                    %                         y1(t2) y2(t2) y3(t2)     %%
                                                    %                           .       .     .   ];   %%
    % ------------------------------------------------------------------------------------------------ %%
    
        T           (1,1)       double              % Final Time                                       %%
    % ------------------------------------------------------------------------------------------------ %%
        
        dt          (1,1)       double              % time interval                                    %%
    % ------------------------------------------------------------------------------------------------ %%
    end
    %% Dont' Show by console
    properties (Hidden)
    % ------------------------------------------------------------------------------------------------ %%
    %   Name     | Dimension  |    Type               |   Description                                  %%
    % ------------------------------------------------------------------------------------------------ %%        
        symY                       sym                  % Symbolic vector Y = [y1 y2 y3 ...]^T         %%
    % ------------------------------------------------------------------------------------------------ %%
        symU                       sym                  % Symbolic vector U = [u1 u2 u3 ...]^T         %%
    % ------------------------------------------------------------------------------------------------ %%
    end
    %% Fake Properties 
    properties (Dependent = true)
        tline
    end
    
    
    methods
        function obj = ode(symF,symY,symU,varargin)
            %ODE 
            
            %% Control input Parameters 
            p = inputParser;
            
            addRequired(p,'symF')
            addRequired(p,'symY')
            addRequired(p,'symU')
            addOptional(p,'Y0',zeros(length(symY),1))
            addOptional(p,'dt',0.1)
            addOptional(p,'T',1)
            
            parse(p,symF,symY,symU,varargin{:})
            
            obj.dt = p.Results.dt;
            obj.Y0 = p.Results.Y0;
            obj.T  = p.Results.T;
            obj.dt = p.Results.dt;
            %% Init Program
            syms t
            
            obj.symY = symY;
            obj.symU = symU;
            
            obj.symF = symfun(symF,[t,symY.',symU.']);
            
            obj.numF = matlabFunction(obj.symF);
            obj.numF  = VectorialForm(obj.numF,[t,symY.',symU.'],'(t,Y,U)');
   
            
        end
        
        function tline = get.tline(obj)
                tline = 0:obj.dt:obj.T;
        end
    end
end

