classdef pode < ode
    %PODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ValuesOfParameter
        
    end
    
    methods
        function obj = pode(ValuesOfParameter,varargin)
            %PODE Construct an instance of this class
            %   Detailed explanation goes here
            p = inputParser;
            
            addRequired(p,'ValuesOfParameter',[])

            addOptional(p,'DynamicEquation',[])
            addOptional(p,'VectorState',[])
            addOptional(p,'Control',[])
            
            addOptional(p,'A',[])
            addOptional(p,'B',[])

            
            addOptional(p,'dt',0.1)
            addOptional(p,'FinalTime',1)
            addOptional(p,'Condition',[])

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
        
            @ode()
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

