classdef constraints < handle
    %CONTRAINTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        EqualityEnd   
        EqualityPath 
        %
        InequalityEnd   
        InequalityPath
    end
    
    methods
        %
        function obj = constraints(EqualityEnd,EqualityPath,InequalityEnd,InequalityPath,Dyn)
            
            [ts,Ys,Us] = symvars(Dyn);

            if ~isempty(EqualityEnd)
                obj.EqualityEnd = casadi.Function('C_f',{Ys},{EqualityEnd});
            end
            if ~isempty(EqualityPath)
                obj.EqualityPath = casadi.Function('C_p',{ts,Ys,Us},{EqualityPath});
            end
            if ~isempty(InequalityEnd)
                obj.InequalityEnd = casadi.Function('G_f',{Ys},{InequalityEnd});
            end
            if ~isempty(InequalityPath)
                obj.InequalityPath = casadi.Function('G_p',{ts,Ys,Us},{InequalityPath});
            end
        end
    end
end

