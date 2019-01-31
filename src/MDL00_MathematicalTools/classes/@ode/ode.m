classdef ode < handle & matlab.mixin.Copyable & matlab.mixin.SetGet
    % description: The class ode structure the idea of an ordinary differential equation, 
    %               so that in this way you can create different methods on the same matlab
    %               structure. Given that matlab leaves a freedom to define the representation
    %               of an equation, we chose to create a matlab class with the most important 
    %               properties of an ODE.
    % visible: true
    properties
        % type: "Symbolic"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Vector of State"
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
        lineal      logical  = false
        A           double
        B           double
        symt 
    end
    %% Fake Properties 
    properties (Dependent = true)
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: "Time grid to plot the solution, and interpolate the control"
        tline                                               double
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
        function obj = ode(DynamicEquation,VectorState,Control,varargin)
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
            %       dimension: [length(iCP.tline)]
            %       default:   empty   
            
            %% Control input Parameters 
            p = inputParser;
            
            addRequired(p,'DynamicEquation')
            addRequired(p,'VectorState')
            addRequired(p,'Control')
            addOptional(p,'dt',0.1)
            addOptional(p,'FinalTime',1)
            addOptional(p,'Condition',zeros(length(VectorState),1))
            addOptional(p,'sym',true)

            parse(p,DynamicEquation,VectorState,Control,varargin{:})
            
            obj.dt              = p.Results.dt;
            obj.Condition       = p.Results.Condition;
            obj.FinalTime       = p.Results.FinalTime;
            obj.dt              = p.Results.dt;
            %% Init Program
            
            syms t
            obj.symt                    = t;
            obj.VectorState.Symbolic    = VectorState;
            obj.VectorState.Numeric     = [];
            obj.Control.Symbolic        = Control;
            obj.Control.Numeric         = [];

            obj.Dynamic.Symbolic = symfun(DynamicEquation,[t,VectorState.',Control.']);
            obj.Dynamic.Numeric   = matlabFunction(obj.Dynamic.Symbolic,'Vars',{t,VectorState,Control});
            
        end
        %% ================================================================================
        %
        %% ================================================================================
        function tline = get.tline(obj)
                tline = 0:obj.dt:obj.FinalTime;
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

