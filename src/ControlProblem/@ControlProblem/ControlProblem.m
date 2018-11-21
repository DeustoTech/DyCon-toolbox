classdef ControlProblem < handle
    %AVERAGECONTROL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Jfun 
        ode               
        P
    end
    
    properties (Hidden)
        
        
        
        uOptimal
        Jhistory
        xhistory
        uhistory
        iter
        time
        dimension
        tline

    end
    
     
    methods
        function obj = ControlProblem(iode,Jfun,varargin)
            
            p = inputParser;
            
            addRequired(p,'iode');
            addRequired(p,'JFunctional');
            
            parse(p,iode,Jfun,varargin{:})
            
            obj.ode          = iode;
            obj.Jfun         = Jfun;
            
            
        end
        
    end
end

