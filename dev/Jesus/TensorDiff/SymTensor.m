classdef SymTensor
    %TENSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sym         sym
        dimension   double = 1
    end
    
    methods
        function obj = SymTensor(sym)
           obj.sym = sym;
        end
        
        function show(obj)
            str = ['a','b','c','d'];
            
            display([newline,'  ',char(obj.sym),'_{',str(1:length(obj.dimension)),'}',newline])
        end
    end
end

