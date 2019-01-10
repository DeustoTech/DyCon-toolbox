classdef LinearControl < ControlProblem
% description: LinearControl is a subclass of the ControlProblem class, so it is also a control problem. 
%               However, we assume that the differential equation we want to control is linear. This gives 
%               us access to new functions such as the conjugate gradient. In addition, it lightens the 
%               computational cost and some functions such as GetAdjointProblem.
% visible: true
    properties
        % type: double
        % default: none
        % description: Gramian Matrix
        gramian = [] 
        % type: double
        % default: space
        % description: MATLAB class that represent de dynamics
        ss
    end
    methods
        function obj = LinearControl(iLinearODE,Jfun,varargin)
        % name: ControlProblem
        % description: 
        % autor: JOroya
        % MandatoryInputs:   
        %   iode: 
        %       name: Linear Ordinary Differential Equation 
        %       description: Ordinary Differential Equation represent the constrain to minimization the functional 
        %       class: LinearODE
        %       dimension: [1x1]
        %   Jfun: 
        %       name: functional
        %       description: Cost function to obtain the optimal control 
        %       class: Functional
        %       dimension: [1x1]        
        % OptionalInputs:
        %   T:
        %       name: Final Time 
        %       description: This parameter represent the final time of simulation.  
        %       class: double
        %       dimension: [1x1]
        %       default: iode.T 
        %   dt:
        %       name: Final Time 
        %       description: This parameter represent is the interval to interpolate the control, $u$, and state, $y$, to obtain the functional $J$ and the gradient $dH/du$
        %       class: double
        %       dimension: [1x1]
        %       default: iode.dt         
        % Outputs:
        %   obj:
        %       name: ControlProblem MATLAB
        %       description: ControlProblem MATLAB class
        %       class: ControlProblem
        %       dimension: [1x1]

            obj@ControlProblem(iLinearODE,Jfun,varargin{:});
                
            
            A = iLinearODE.A;
            B = iLinearODE.B;
            
            obj.ss = ss(A,B,[],[]);
            %obj.cgramian = gram(obj.ss,'c');
            %obj.ogramian = gram(obj.ss,'o');

        end
        
    end
end

