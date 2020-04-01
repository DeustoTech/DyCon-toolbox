classdef fun < handle
    %FUNC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sym  casadi.SX
        num  double
        expr function_handle
    end
    
    methods
        function obj = fun(sym,num)
            %FUNC Construct an instance of this class
            %   Detailed explanation goes here
            obj.sym = sym;
            obj.num = num;
        end
    end
end

