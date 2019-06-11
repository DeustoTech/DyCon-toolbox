classdef ode < handle & matlab.mixin.Copyable & matlab.mixin.SetGet
    % description:  The ode class is an object that will contain all the information 
    %              to solve a differential equation. This can be the equation of the dynamics,
    %              initial condition, or the solution method itself. This class is necessary in
    %              order to generalize the optimal control methods used in other packages.
    % long: This class is the representation of an ode
    %               $$ \dot{Y} = f(t,Y,U) \ \  Y(0) = Y_0$$
    %       where 
    %           $$ Y = \begin{pmatrix} y_1 \\ y_2 \\..  \\ y_n  \end{pmatrix} \text{   ,   }
    %              U  = \begin{pmatrix} u_1 \\ u_2 \\..  \\u_m   \end{pmatrix} $$
    %       This class is necessary in the toolbox since within the toolbox to be able to systematize
    %       some algorithms. You can create ode objects, which are capable of parameterizing so that 
    %       with a solve statement it is solved. In this way, we can write the "solve" command within
    %       our algorithms, without losing versatility in the solution of the equation. Let's see some
    %       examples to make that clearer.
    properties
        %%
        % type: "Struct"
        % dimension: [1x1]
        % default: "none"
        % description:  "MATLAB Structure that contain the two properties
        %               <ul>
        %                   <li> Symbolic - Symbolic Vector State [y1 y2 ...] </li>
        %                   <li> Numeric  - Numeric solution of the equation. 
        %                                   The numeric property only is
        %                                   aviable if previus solve the equation. 
        %                   </li>
        %               </ul>"
        StateVector       
        %%
        % type: "Struct"
        % dimension: [1x1]
        % default: "none"
        % description:  MATLAB Structure that contain the two properties
        %               <ul>
        %                   <li> Symbolic - Symbolic Vector State [u1 u2 ...] </li>
        %                   <li> Numeric  - matrix Numeric control to solve the equation. 
        %                                   $$\\dot{Y} = f(t,\\dot{Y},U)$$ 
        %                   </li>
        %               </ul>
        Control                                                  
        % type: "Struct"
        % dimension: [1x1]
        % default: "none"
        % description:  MATLAB Structure that contain the two properties
        %               <ul>
        %                   <li> Symbolic - symbolic function of dynamics equation </li>
        %                   <li> Numeric  - function_handle of dynamics equation. 
        %                   </li>
        %               </ul>
        DynamicEquation                 SymNumFun =SymNumFun
        DerivativeDynControl            SymNumFun =SymNumFun
        DerivativeDynState              SymNumFun =SymNumFun
        % type: "double"
        % dimension: [1xN]
        % default: "[0 0 0 ...]"
        % description: "Initial State or Final State dependent of property Type"
        InitialCondition                                                                double     
        % type: "double"
        % dimension: [1x1]
        % default: "1"
        % description: "Time final of simulation"
        FinalTime                                   (1,1)                           double                                                            
        % type: "double"
        % dimension: [1x1]
        % default: "none"
        % description: "Time interval of plots. ATTENTION - the solution of ode is obtain by ode45, with adatative step"
        Nt                                          (1,1)                           double  
        MassMatrix
        label = '' 
        Solver = @ode23tb
        SolverParameters = {}
        
    end

    properties (Hidden)
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description:  A matrix of lineal problems. If this property is empty, so the ode is not lineal. 
        %                 $$ \dot{Y} = \textbf{A}Y + BU $$
        A
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: B matrix of lineal problems. If this property is empty, so the ode is not lineal. 
        %                 $$ \dot{Y} = AY + \textbf{B}U $$
        B
        % type: "double"
        % dimension: [NxN]
        % default: "none"
        % description: B matrix of lineal problems. If this property is empty, so the ode is not lineal. 
        %                 $$ \dot{Y} = AY + \textbf{B}U $$
        C
        % type: "logical"
        % dimension: [MxN]
        % default: "false"
        % description: This indicator represent the lineal or non-lineal.      
        lineal      logical  = false
        % type: "Symbolic"
        % dimension: [1x1]
        % default: "t"
        % description: Represent the symbolic time 
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
        % description: "Dimension of Control Vector"
        ControlDimension
        StateDimension
        dt
    end
    
    
    methods
        function obj = ode(varargin)
            % description: The ode class, if only de organization of ode.
            %               The solve of this class is the RK family.
            % autor: JOroya
            % OptionalInputs:
            %   DynamicEquation: 
            %       description: simbolic expresion
            %       class: Symbolic
            %       dimension: [1x1]
            %   StateVector: 
            %       description: StateVector
            %       class: Symbolic
            %       dimension: [1x1]
            %   Control: 
            %       description: simbolic expresion
            %       class: Symbolic
            %       dimension: [1x1]
            %   A: 
            %       description: simbolic expresion
            %       class: matrix
            %       dimension: [1x1]
            %   B: 
            %       description: simbolic expresion
            %       class: matrix
            %       dimension: [1x1]            
            %   InitialControl:
            %       name: Initial Control 
            %       description: matrix 
            %       class: double
            %       dimension: [length(iCP.tspan)]
            %       default:   empty   
            
            %% Control input Parameters 
            p = inputParser;
            
            addOptional(p,'DynamicEquation',[],@ValidatorODEDynamicsEquation)
            addOptional(p,'StateVector'    ,[],@ValidatorODEStateVector)
            addOptional(p,'Control'        ,[],@ValidatorODEStateVector)
            
            addOptional(p,'A',[])
            addOptional(p,'B',[])

            
            addOptional(p,'Nt',10,@DTValidNt)
            addOptional(p,'FinalTime',1)
            addOptional(p,'InitialCondition',[])

            parse(p,varargin{:})
            
            DynamicEquation     = p.Results.DynamicEquation;
            StateVector         = p.Results.StateVector;
            Control             = p.Results.Control;
            
            obj.A              = p.Results.A;
            obj.B              = p.Results.B;

            obj.Nt              = p.Results.Nt;
            obj.FinalTime       = p.Results.FinalTime;
            obj.InitialCondition       = p.Results.InitialCondition;
            
            %% Init Program
            if  (~isempty(DynamicEquation) && ~isempty(StateVector) && ~isempty(Control) ...
                 && isempty(obj.A) && isempty(obj.B) )
                    
                   obj.lineal = false;
                   try
                        Ny = length(StateVector);
                        Nu = length(Control);
                        Fresp = DynamicEquation(0,zeros(Ny,1),zeros(Nu,1));
                        [FrespNrow,FrespNcol] = size(Fresp);
                        if FrespNrow ~= Ny || FrespNcol ~= 1
                            error(['The dynamics equation must be return the column vector of dimension: [',num2str(Ny),'x1]'])
                        end
                   catch err
                        err.getReport
                        error(['You have a some problem in the definition of the dynamics equation.'])
                   end
            elseif (isempty(DynamicEquation) && isempty(StateVector) && isempty(Control) ...
                 && ~isempty(obj.A) )
             
                   obj.lineal = true;
            else
                error([newline, ...
                        'You can define the class ode in two different way:',newline, ...
                        '   - ode(DynamicEquation,StateVector,Control)    ',newline, ...
                        '   - ode(''A'',A,''B'',B)                        ',newline])
            end
            
            %%
            obj.symt                    = sym('t');

            if ~obj.lineal
                %%  Ha entrado variables simbolicas
                obj.StateVector.Symbolic      = StateVector;                
                obj.Control.Symbolic          = Control;
                obj.DynamicEquation.Numerical   = DynamicEquation;
                obj.DynamicEquation.Symbolical   = [];

            else
                %% Han entrado matrices A y B 
                [nrow,~ ] = size(obj.A);
                
                % Creamos la estructura para el vector de estado 
                obj.StateVector.Symbolic = sym('y',[nrow 1]);
                
                % Creamos la estructura para el control
                [~ ,ncol] = size(obj.B);
                obj.Control.Symbolic        = sym('u',[ncol 1]) ;
               %

                if ~isempty(obj.B)
                    obj.DynamicEquation.Numerical   = @(t,Y,U) obj.A*Y + obj.B*U;
                else
                    obj.DynamicEquation.Numerical   = @(t,Y,U) obj.A*Y;
                end
                % Por defecto 
                obj.Solver          = @euleri;
                obj.DerivativeDynControl.Numerical = @(t,Y,U) obj.B;
                obj.DerivativeDynState.Numerical   = @(t,Y,U) obj.A;
            end
             
            obj.Control.Numeric = zeros(length(obj.tspan),obj.ControlDimension);
            obj.MassMatrix      = eye(obj.StateDimension);
            %
            if isempty(obj.InitialCondition)
                obj.InitialCondition =  zeros(obj.StateDimension,1);
            end

        end
        %% ================================================================================
        %
        %% ================================================================================
        function dt = get.dt(obj)
                dt = obj.FinalTime/(obj.Nt);
        end
        
        function tspan = get.tspan(obj)
                tspan = linspace(0,obj.FinalTime,obj.Nt);
        end
        %%
        function ControlDimension = get.ControlDimension(obj)
            if ~(obj.lineal)
               ControlDimension =  length(obj.Control.Symbolic);
            elseif ~isempty(obj.B) 
               [~, ControlDimension ] =  size(obj.B);
            else
                ControlDimension = 0;
            end
        end
        %%
        function StateDimension = get.StateDimension(obj)
            if obj.lineal
                [StateDimension, ~] = size(obj.A);
            else
                StateDimension =  length(obj.StateVector.Symbolic);
            end
        end
        %% ================================================================================

        function set.FinalTime(obj,FinalTime)
            obj.FinalTime = FinalTime;
            if ~ isempty(obj.Control)
                obj.Control.Numeric = zeros(length(obj.tspan),obj.ControlDimension);
            end
        end
        
        function set.Nt(obj,Nt)
            obj.Nt = Nt;
            if ~isempty(obj.Control)
                obj.Control.Numeric = zeros(obj.Nt,obj.ControlDimension);
            end
        end
        %% ================================================================================
    end
end

