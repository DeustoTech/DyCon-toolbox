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
        % description: "Solution of problem. If the problem hasn't been solved this property is empty"
        Y                                                   double                                                         
        % type: "double"
        % dimension: [1x1]
        % default: "none"
        % description: "Control with has been solve the problem. If the problem hasn't been solved this property is empty"
        U                                                   double  
        % type: logical
        % dimesion: [1x1]
        % default: true
        % description "If this property is false, the ode is only numerical. The property symF, symY, symU are empty"
        sym                                                 logical
        % type: double
        % dimesion: [1x1]
        % default: none
        % description Dimesion of control
        Udim                                                double
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
            %   symF: 
            %       description: simbolic expresion
            %       class: symbolic
            %       dimension: [1x1]
            %   symY: 
            %       description: simbolic expresion
            %       class: symbolic
            %       dimension: [1x1]
            %   symU: 
            %       description: simbolic expresion
            %       class: symbolic
            %       dimension: [1x1]
            % OptionalInputs:
            %   U0:
            %       name: Initial Control 
            %       description: matrix 
            %       class: double
            %       dimension: [length(iCP.tline)]
            %       default:   empty   
            
            %% Control input Parameters 
            p = inputParser;
            
            addRequired(p,'symF')
            addRequired(p,'symY')
            addRequired(p,'symU')
            addOptional(p,'dt',0.1)
            addOptional(p,'T',1)
            addOptional(p,'Y0',zeros(length(symY),1))
            addOptional(p,'sym',true)
            addOptional(p,'numF',[])


            parse(p,symF,symY,symU,varargin{:})
            
            obj.dt = p.Results.dt;
            obj.Y0 = p.Results.Y0;
            obj.T  = p.Results.T;
            obj.dt = p.Results.dt;
            obj.sym = p.Results.sym;
            numF    = p.Results.numF;
            %% Init Program
            if obj.sym
                syms t

                obj.symY = symY;
                obj.symU = symU;

                obj.symF = symfun(symF,[t,symY.',symU.']);

                obj.numF = matlabFunction(obj.symF);
                obj.numF  = VectorialForm(obj.numF,[t,symY.',symU.'],'(t,Y,U)');
                obj.Udim =  length(symU);

            else
                if isempty(numF)
                   error('If sym is false, you must put the parameter numF') 
                end
                obj.numF = numF;
            end

   
            
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

