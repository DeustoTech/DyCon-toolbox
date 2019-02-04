classdef ode < handle & matlab.mixin.Copyable & matlab.mixin.SetGet
    % description: The class ode structure the idea of an ordinary differential equation, 
    %               so that in this way you can create different methods on the same matlab
    %               structure. Given that matlab leaves a freedom to define the representation
    %               of an equation, we chose to create a matlab class with the most important 
    %               properties of an ODE.
    % visible: true
    properties
        % type: "Struct"
        % dimension: [1x1]
        % default: "none"
        % description: MATLAB Structure that contain the two properties,
        %               Numeric and Symbolic. This represent the symbolic
        %               version of the control state, and numeric solution
        %               of the equation. The numeric property only is
        %               aviable if previus solve the equation.
        %               
        VectorState                                                                              
        % type: "Symbolic"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Vector of Control"
        Control                                                  
        % type: "Symbolic function"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Expresion of Y'=F(Y,U)"
        Dynamic                                                                                
        % type: "double"
        % dimension: [1xN]
        % default: "[0 0 0 ...]"
        % description: "Initial State"
        Condition                                                                double     
        % type: "double"
        % dimension: [1xN]
        % default: "[0 0 0 ...]"
        % description: "Final State"
        Type        {mustBeMember(Type,{'FinalCondition','InitialCondition'})} = 'InitialCondition'                                                                    
        % type: "double"
        % dimension: [1x1]
        % default: "1"
        % description: "Time final of simulation"
        FinalTime                                   (1,1)                           double                                                            
        % type: "double"
        % dimension: [1x1]
        % default: "none"
        % description: "Time interval of plots. ATTENTION - the solution of ode is obtain by ode45, with adatative step"
        dt                                          (1,1)                           double                                                      
    end

    properties (Hidden)
        A
        B
        lineal      logical  = false
        symt 
    end
    %% Fake Properties 
    properties (Dependent = true)
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: "Time grid to plot the solution, and interpolate the control"
        tspan                                               double
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: "Time grid to plot the solution, and interpolate the control"
       
        Yend
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: "Time grid to plot the solution, and interpolate the control"
        Udim
    end
    
    
    methods
        function obj = ode(varargin)
            % description: Constructor the ecuacion diferencial
            % autor: JOroya
            % MandatoryInputs:   
            %   DynamicEquation: 
            %       description: simbolic expresion
            %       class: Symbolic
            %       dimension: [1x1]
            %   VectorState: 
            %       description: simbolic expresion
            %       class: Symbolic
            %       dimension: [1x1]
            %   Control: 
            %       description: simbolic expresion
            %       class: Symbolic
            %       dimension: [1x1]
            % OptionalInputs:
            %   InitialControl:
            %       name: Initial Control 
            %       description: matrix 
            %       class: double
            %       dimension: [length(iCP.tspan)]
            %       default:   empty   
            
            %% Control input Parameters 
            p = inputParser;
            
            addOptional(p,'DynamicEquation',[])
            addOptional(p,'VectorState',[])
            addOptional(p,'Control',[])
            
            addOptional(p,'A',[])
            addOptional(p,'B',[])

            
            addOptional(p,'dt',0.1)
            addOptional(p,'FinalTime',1)
            addOptional(p,'Condition',[])
            addOptional(p,'sym',true)

            parse(p,varargin{:})
            
            DynamicEquation     = p.Results.DynamicEquation;
            VectorState         = p.Results.VectorState;
            Control             = p.Results.Control;
            
            obj.A              = p.Results.A;
            obj.B              = p.Results.B;

            obj.dt              = p.Results.dt;
            obj.Condition       = p.Results.Condition;
            obj.FinalTime       = p.Results.FinalTime;
            obj.Condition       = p.Results.Condition;
            %% Init Program
            if  (~isempty(DynamicEquation) && ~isempty(VectorState) && ~isempty(Control) ...
                 && isempty(obj.A) && isempty(obj.B) )
                    
                   obj.lineal = false;
                   
            elseif (isempty(DynamicEquation) && isempty(VectorState) && isempty(Control) ...
                 && ~isempty(obj.A) && ~isempty(obj.B) )
             
                   obj.lineal = true;
                    
            end
            
            %%
            syms t
            obj.symt                    = t;

            if ~obj.lineal
                Y    = VectorState;
                obj.VectorState.Symbolic    = Y;
                obj.VectorState.Numeric     = [];
                
                U    = Control;
                obj.Control.Symbolic    = U;
                obj.Control.Numeric         = [];
                
                obj.Dynamic.Symbolic  = symfun(DynamicEquation,[t,Y.',U.']);
                obj.Dynamic.Numeric   = matlabFunction(obj.Dynamic.Symbolic,'Vars',{t,Y,U});
            else
                [nrow,ncol] = size(obj.A);
                
                obj.VectorState.Symbolic = sym('y',[nrow 1]);
                Y = obj.VectorState.Symbolic;
                
                obj.VectorState.Numeric     = [];

                [nrow,ncol] = size(obj.B);
                U = sym('u',[ncol 1]) ;
                obj.Control.Symbolic        = U;
                obj.Control.Numeric         = [];

                DynamicEquation = obj.A*Y + obj.B*U;
                
                obj.Dynamic.Symbolic  = symfun(DynamicEquation,[t,Y.',U.']);
                obj.Dynamic.Numeric   = matlabFunction(obj.Dynamic.Symbolic,'Vars',{t,Y,U});
            end
            if isempty(obj.Condition)
                obj.Condition =  zeros(length(Y),1);
            end

        end
        %% ================================================================================
        %
        %% ================================================================================
        function tspan = get.tspan(obj)
                tspan = 0:obj.dt:obj.FinalTime;
        end
        %% ================================================================================
        %
        %% ================================================================================
        function Yend = get.Yend(obj)
                Yend = obj.VectorState.Numeric(end,:);
        end
        %% ================================================================================
        %
        %% ================================================================================
        function Udim = get.Udim(obj)
            Udim =  length(obj.Control.Symbolic);
        end
        %% ================================================================================
        %
        %% ================================================================================
    end
end

