classdef LinearControl < ControlProblem
% description: This class is able to solve optimization problems of a function restricted to an ordinary equation. This scheme is used to solve optimal control problems in which the functional derivative is calculated. <strong>ControlProblem</strong> class has methods that
%               help us find optimal control as well as obtaining the attached problem and it's derivative form, 
%               in both symbolic and numerical versions.
% visible: true
    
    methods
        function obj = LinearControl(iLinearODE,Jfun,varargin)
        % description: This class is able to solve optimization problems of a function restricted to an ordinary equation. This scheme is used to solve optimal control problems in which the functional derivative is calculated. <strong>ControlProblem</strong> class has methods that
        %               help us find optimal control as well as obtaining the attached problem and it's derivative form, 
        %               in both symbolic and numerical versions.
        % visible: true
            
            obj@ControlProblem(iLinearODE,Jfun,varargin{:});

        end
        
    end
end

