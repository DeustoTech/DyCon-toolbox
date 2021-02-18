classdef dtsys < handle & matlab.mixin.Copyable
% dtsys - Discrete Dynamical System. Need 
%   - the evolution function as: @(k,State,Control) F(k,State,Control), 
%   - the Symbolic State by CasADi 
%   - the symbolic Control by CasADi
    
    properties
        DynamicFcn          casadi.Function
        State               fun
        Control             fun
        InitialCondition    casadi.DM
        Nt                  double = 100;
    end
    
    properties (Dependent = true , Hidden = true)
       ControlDimension
       StateDimension 
    end
    
    properties (Hidden = true)
       Jacobians  dtsysJacobians = dtsysJacobians
    end
    methods
        function obj = dtsys(DynamicFcn,State,Control,ts,varargin)
            % dtsys - Discrete Dynamical System. Need 
            %   - the evolution function as: @(k,State,Control) F(k,State,Control), 
            %   - the Symbolic State by CasADi 
            %   - the symbolic Control by CasADi
            p = inputParser;
            addRequired(p,'DynamicFcn')
            addRequired(p,'State')
            addRequired(p,'Control')
            addRequired(p,'ts')
            addOptional(p,'Nt',100)

            
            parse(p,DynamicFcn,State,Control,ts,varargin{:})
            %
            %%
            lenState = length(State);
            lenControl = length(Control);
            %
            numState   = zeros(lenState  , obj.Nt);
            numControl = zeros(lenControl, obj.Nt);
            % Inizializate by default
            obj.State   = fun(State,numState);
            obj.Control = fun(Control,numControl);
            %
            obj.ts = ts;
            
            obj.DynamicFcn = casadi.Function('F',{ts,obj.State.sym,obj.Control.sym},{DynamicFcn});
            %
            % Zeros Initial Condition
            obj.InitialCondition = zeros(lenState,1);
            
        end
        
        %%
        %% SETTERS
        function set.InitialCondition(obj,InitialCondition)
            
             if ~isrow(InitialCondition')
                error('The InitialCondition must be column of the same dimension of State Vector')
             elseif obj.StateDimension ~= length(InitialCondition)
                error('The Initial Condition must be have the same dimension of State Vector')
             end

             obj.InitialCondition = InitialCondition;
        end
        % 
        function set.Nt(obj,Nt)
           if ~isa(obj,'dtsys')
               if length(obj.tspan) ~= Nt 
                  error('Nt is different of length of tspan') 
               end
           end
           obj.Nt = Nt;
        end
        
        %% GETTERS
        
        function result = get.ControlDimension(obj)
           result = length(obj.Control.sym);
        end
        %
        function result = get.StateDimension(obj)
           result = length(obj.State.sym);
        end
        %
        function Nt = get.Nt(obj)
           Nt = obj.Nt;
        end
    end
end

