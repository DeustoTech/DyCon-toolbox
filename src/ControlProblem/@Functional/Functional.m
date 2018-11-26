classdef Functional
    %FUNCTIONAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numPsi
        numL
        symPsi 
        symL
        T
        % derivatives 
    end
    
    properties (Hidden)
        dt
        symU
        symY
    end
    
    properties (Dependent = true)
        tline
    end
    methods
        function obj = Functional(symPsi,symL,symY,symU,varargin)
            
            %%
            p = inputParser;
            
            addRequired(p,'symPsi')
            addRequired(p,'symL')
            addRequired(p,'symY')
            addRequired(p,'symU')
            addOptional(p,'T',1)
            addOptional(p,'dt',0.1)
            
            parse(p,symPsi,symL,symY,symU,varargin{:})
            
            obj.T = p.Results.T;
            obj.dt = p.Results.dt;
            %%
            
            syms t

            obj.symU = symU;
            obj.symY = symY;
            
            obj.symPsi  = symfun(symPsi,[t,symY.']);
            obj.symL    = symfun(symL,[t,symY.',symU.']);

            obj.numL  = matlabFunction(obj.symL);
            obj.numL  = VectorialForm(obj.numL,[t,symY.',symU.'],'(t,Y,U)');
            % 
            obj.numPsi = matlabFunction(obj.symPsi);
            obj.numPsi = VectorialForm(obj.numPsi,[t,symY.'],'(t,Y)');
            
            %%
            
        end
        
    end
end

