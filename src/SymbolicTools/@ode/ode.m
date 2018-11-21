classdef ode
    %ODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        symF
        X0
    end
    
    properties (Hidden)
        dt
        tline 
        numF
        symX
        symU
    end
    
    methods
        function obj = ode(symF,symX,symU,X0,varargin)
            %ODE Construct an instance of this class
            %   Detailed explanation goes here
            
            p = inputParser;
            
            addRequired(p,'symF')
            addRequired(p,'symX')
            addRequired(p,'symU')
            addRequired(p,'X0')
            addOptional(p,'dt',0.1)
            
            parse(p,symF,symX,symU,X0,varargin{:})
            
            obj.dt = p.Results.dt;
            
            syms t
            
            obj.symX = symX;
            obj.symU = symU;
            obj.X0 = X0;
            
            obj.symF = symfun(symF,[t,symX.',symU.']);
            
            obj.numF = matlabFunction(obj.symF);
            obj.numF  = VectorialForm(obj.numF,[t,symX.',symU.'],'(t,X,U)');
   
            
        end
        

    end
end

