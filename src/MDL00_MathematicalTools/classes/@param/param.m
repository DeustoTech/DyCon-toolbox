classdef param < handle
    %PARAMETER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sym     sym 
        value   (1,1) double
    end
    
    methods
        function obj = param(ch,value)
           obj.sym = sym(ch);
           obj.value = value;
        end
    end
end

