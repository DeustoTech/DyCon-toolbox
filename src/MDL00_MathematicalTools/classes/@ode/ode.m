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
        DynamicEquation                                                                                
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
        dt                                          (1,1)                           double  
        MassMatrix
        label = '' 
        Solver = @ode45
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
        Udim
        Ydim
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
            
            addOptional(p,'DynamicEquation',[])
            addOptional(p,'StateVector',[])
            addOptional(p,'Control',[])
            
            addOptional(p,'A',[])
            addOptional(p,'B',[])

            
            addOptional(p,'dt',0.1)
            addOptional(p,'FinalTime',1)
            addOptional(p,'InitialCondition',[])

            parse(p,varargin{:})
            
            DynamicEquation     = p.Results.DynamicEquation;
            StateVector         = p.Results.StateVector;
            Control             = p.Results.Control;
            
            obj.A              = p.Results.A;
            obj.B              = p.Results.B;

            obj.dt              = p.Results.dt;
            obj.FinalTime       = p.Results.FinalTime;
            obj.InitialCondition       = p.Results.InitialCondition;
            
            %% Init Program
            if  (~isempty(DynamicEquation) && ~isempty(StateVector) && ~isempty(Control) ...
                 && isempty(obj.A) && isempty(obj.B) )
                    
                   obj.lineal = false;
                   
            elseif (isempty(DynamicEquation) && isempty(StateVector) && isempty(Control) ...
                 && ~isempty(obj.A) )
             
                   obj.lineal = true;
                    
            end
            
            %%
            syms t
            obj.symt                    = t;

            if ~obj.lineal
                %%  Ha entrado variables simbolicas
                Y    = StateVector;
                obj.StateVector.Symbolic    = Y;
                obj.StateVector.Numeric     = [];
                
                index = 0;
                
                for iU = Control
                    index = index + 1;
                    obj.Control(index).Symbolic        = iU;
                    obj.Control(index).Numeric         = [];
                end
                U =  [obj.Control.Symbolic];
                
                obj.DynamicEquation.Symbolic  = symfun(DynamicEquation,[t,Y.',U.']);
                obj.DynamicEquation.Numeric   = matlabFunction(obj.DynamicEquation.Symbolic,'Vars',{t,Y,U});
                
            else
                %% Han entrado matrices A y B 
                %[nrow,~ ] = size(obj.A);
                
                % Creamos la estructura para el vector de estado 
                %obj.StateVector.Symbolic = sym('y',[nrow 1]);
                obj.StateVector.Symbolic =[];

                %Y = obj.StateVector.Symbolic;
                
                obj.StateVector.Numeric     = [];
                % Creamos la estructura para el control
                %[~ ,ncol] = size(obj.B);
                %U = sym('u',[ncol 1]) ;
                %obj.Control.Symbolic        = U;
                obj.Control.Numeric         = [];
                obj.Control.Symbolic =[];
               %
                if ~isempty(obj.B)
                    %DynamicEquation = obj.A*Y + obj.B*U;
                    %obj.DynamicEquation.Symbolic  = symfun(DynamicEquation,[t,Y.',U.']);
                    obj.DynamicEquation.Numeric   = @(t,Y,U) obj.A*Y + obj.B*U;
                else
                    %DynamicEquation = obj.A*Y;
                    %obj.DynamicEquation.Symbolic  = symfun(DynamicEquation,[t,Y.']);
                    obj.DynamicEquation.Numeric   = @(t,Y,U) obj.A*Y;
                end
                % Por defecto 
                obj.Solver          = @euleri;
            end
             
            obj.Control.Numeric = zeros(length(obj.tspan),obj.Udim);
            obj.MassMatrix      = eye(obj.Ydim);
            if isempty(obj.InitialCondition)

                obj.InitialCondition =  zeros(obj.Ydim,1);
                
            end

        end
        %% ================================================================================
        %
        %% ================================================================================
        function tspan = get.tspan(obj)
                tspan = 0:obj.dt:obj.FinalTime;
        end
        %%
        function Udim = get.Udim(obj)
            if ~isempty(obj.Control.Symbolic)
               Udim =  length(obj.Control.Symbolic);
            elseif ~isempty(obj.B) 
               [Udim, ~ ] =  size(obj.B);
            else
                Udim = 0;
            end
        end
        %%
        function Ydim = get.Ydim(obj)
            if obj.lineal
                [Ydim, ~] = size(obj.A);
            else
                Ydim =  length(obj.StateVector.Symbolic);
            end
        end
        %% ================================================================================
        function set.dt(obj,dt)
            obj.dt = dt;
            if ~ isempty(obj.Control)
                obj.Control.Numeric = zeros(length(obj.tspan),obj.Udim);
            end
        end
        function set.FinalTime(obj,FinalTime)
            obj.FinalTime = FinalTime;
            if ~ isempty(obj.Control)
                obj.Control.Numeric = zeros(length(obj.tspan),obj.Udim);
            end
        end
        %% ================================================================================
    end
end

