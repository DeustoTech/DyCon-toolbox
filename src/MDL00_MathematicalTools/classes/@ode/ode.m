classdef ode < handle & matlab.mixin.Copyable & matlab.mixin.SetGet
    % description: The class ode structure the idea of an ordinary differential equation, 
    %               so that in this way you can create different methods on the same matlab
    %               structure. Given that matlab leaves a freedom to define the representation
    %               of an equation, we chose to create a matlab class with the most important 
    %               properties of an ODE.
    % visible: true
    properties
        % type: "symbolic"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Vector of State"
        symY                                                sym                              
        % type: "symbolic"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Vector of Control"
        symU                                                sym                    
        % type: "function_handle"
        % dimension: [1x1]
        % default: "none"
        % description: "Numerical Expresion of Y'=F(Y,U)"
        numF                                                function_handle          
        % type: "symbolic function"
        % dimension: [1x1]
        % default: "none"
        % description: "Symbolic Expresion of Y'=F(Y,U)"
        symF                                                sym                                            
        % type: "double"
        % dimension: [1xN]
        % default: "[0 0 0 ...]"
        % description: "Initial State"
        Y0                                                  double     
        % type: "double"
        % dimension: [1xN]
        % default: "[0 0 0 ...]"
        % description: "Final State"
        YT                                                  double  
        % type: "double"
        % dimension: [1x1]
        % default: "1"
        % description: "Time final of simulation"
        T                     (1,1)                         double                                                            
        % type: "double"
        % dimension: [1x1]
        % default: "none"
        % description: "Time interval of plots. ATTENTION - the solution of ode is obtain by ode45, with adatative step"
        dt                    (1,1)                         double                                                      
        % type: "double"
        % dimension: [1x1]
        % default: "none"
        % description: "Solution of problem"
        Y                                                   double   
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
    end
    
    
    methods
        function obj = ode(symF,symY,symU,varargin)
            % description: Metodo de Es
            % autor: JOroya
            % MandatoryInputs:   
            % iCP: 
            %    name: Control Problem
            %    description: 
            %    class: ControlProblem
            %    dimension: [1x1]
            % OptionalInputs:
            % U0:
            %    name: Initial Control 
            %    description: matrix 
            %    class: double
            %    dimension: [length(iCP.tline)]
            %    default:   empty   
            
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
        %%
        function tline = get.tline(obj)
                tline = 0:obj.dt:obj.T;
        end
        %%
        function Yend = get.Yend(obj)
                Yend = obj.Y(end,:);
        end
        %% 
        function obj = set.Y0(obj,Y0) 
            obj.Y0 = Y0; 
            obj.Y = [];
        end
    end
end

