classdef var
    %VAR 
    properties
        Name
        Line
        N
    end
    
    methods
        function obj = var(name,Line)
            % Class que contiene un variable
            obj.Line = Line;
            obj.N = length(Line);
            obj.Name = name;
        end
        
        function ind = value2index(obj,value)
            [~,ind] = min(abs(value-obj.Line));
        end
    end
end

