classdef Functional
    %FUNCTIONAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        symPsi 
        symL
        % derivatives 
    end
    
    properties (Hidden)
        numPsi
        numL
        symU
        symX
    end

    methods
        function obj = Functional(symPsi,symL,symX,symU)
            syms t

            obj.symU = symU;
            obj.symX = symX;
            
            obj.symPsi  = symfun(symPsi,[t,symX.']);
            obj.symL    = symfun(symL,[t,symX.',symU.']);

            obj.numL  = matlabFunction(obj.symL);
            obj.numL  = VectorialForm(obj.numL,[t,symX.',symU.'],'(t,X,U)');
            % 
            obj.numPsi = matlabFunction(obj.symPsi);
            obj.numPsi = VectorialForm(obj.numPsi,[t,symX.'],'(t,X)');
            

        end
        
    end
end

