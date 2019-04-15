classdef Pontryagin < AbstractOptimalControl
% description: "This class is able to solve optimization problems of a function restricted to an ordinary equation.
%               This scheme is used to solve optimal control problems in which the functional derivative is calculated. 
%               <strong>OptimalControl</strong> class has methods that help us find optimal control as well as obtaining 
%               the attached problem and it's derivative form, 
%               in both Symbolic and numerical versions."
% long:  This class is able to solve optimal control problems. Optimal control refers to the problem of finding a control law
%           for a given system such that a certain optimality criterion is achieved. The essential features of an optimal control problem are 
%               <ul>
%               <li> a cost functional to be minimized;</li>
%               <li> an initial/boundary value problem for a differential equation describing the motion, in order to determine the state of the system;</li>
%               <li> a control function;</li>
%               <li> eventual constraints that have to be obeyed.</li>
%               </ul>
%               The control may be freely chosen within the given constraints, while the state is uniquely determined by the differential equation and the initial conditions.
%               We have to choose the control in such a way that the cost function is minimized. This class allows treating general optimal control problems in the form
%               $$ \begin{equation*}
%                   \min_{u\in\mathcal{U}} J,
%               \end{equation*} $$
%                in which the objective functional $J$ is defined as
%                $$ \begin{equation*}
%                   J=\Psi (x(T))+\int _{0}^{T}\mathcal{L}(x(t),u(t)),dt
%               \end{equation*} $$
%               and where $x$ is the state of a dynamical system with input $u\in\mathcal{U}$, the set of admissible controls 
%               $$\begin{equation*} \dot {x}=f(x,u),\quad x(0)=x_{0},\quad
%               u(t)\in\mathcal {U},\quad t\in [0,T]. \end{equation*}$$
%               Moreover, the class permits to choose among different methods for solving the minimization problem. At the present stage, the methods available are
%                 <ul>
%                   <li>  <a href='https://deustotech.github.io/dycon-platform-documentation/documentation/mdl01/optimalcontrol/ClassicalDescent'>Classical gradient method</a></li>
%                   <li>  <a href='https://deustotech.github.io/dycon-platform-documentation/documentation/mdl01/optimalcontrol/AdaptativeDescent'>Gradient method with adaptive descend step</a></li>
%                   <li>  <a href='https://deustotech.github.io/dycon-platform-documentation/documentation/mdl01/optimalcontrol/ConjugateGradientDescent'>Conjugate gradient method</a></li>
%                 </ul>

properties
   Target 
end
     
    methods
        function obj = Pontryagin(iode,symPsi,symL,varargin)
        % name: ControlProblem
        % description: 
        % autor: JOroya
        % MandatoryInputs:   
        %   iode: 
        %       name: Ordinary Differential Equation 
        %       description: Ordinary Differential Equation represent the constrain to minimization the functional 
        %       class: ode
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

            p = inputParser;
            
            addRequired(p,'iode');
            
            addRequired(p,'symPsi');
            addRequired(p,'symL');
                    
            
            addOptional(p,'ControlGradient',[])
            addOptional(p,'Hessian',[])
            addOptional(p,'Adjoint',[])
            addOptional(p,'AdjointFinalCondition',[])
            
            parse(p,iode,symPsi,symL,varargin{:})
            
            t           = iode.symt;
            symU        = iode.Control.Symbolic;
            symY        = iode.StateVector.Symbolic;
            Hessian     = p.Results.Hessian;
            ControlGradient    = p.Results.ControlGradient;

            Adjoint                 = p.Results.Adjoint;
            AdjointFinalCondition   = p.Results.AdjointFinalCondition;
            %% Functiona Definition
            obj.Functional.Psi.Symbolic      = symfun(symPsi,[t,symY.']);
            obj.Functional.Psi.Numeric       = matlabFunction(symPsi,'Vars',{t,symY});

            obj.Functional.L.Symbolic        = symfun(symL,[t,symY.',symU.']);
            obj.Functional.L.Numeric         = matlabFunction(symL,'Vars',{t,symY,symU});
            %% Dynamics Definition                   
            obj.dynamics                 = copy(iode);
            %% Hamiltonian
            
            symP  =  sym('p', [length(symY),1]);
            
            if obj.dynamics.lineal   
                obj.hamiltonian = symL + symP.'*(obj.dynamics.A* obj.dynamics.StateVector.Symbolic + obj.dynamics.B*obj.dynamics.Control.Symbolic);
            else
                obj.hamiltonian = symL + symP.'*formula(obj.dynamics.DynamicEquation.Symbolic);
            end
            
            %% Direccion del Gradiente
            
            if isempty(ControlGradient)
                GetSymbolicalGradient(obj);
            else
                obj.ControlGradient.Numerical = ControlGradient;
            end
            
            if isempty(Hessian)
                if ~isempty(ControlGradient)
                    warning('If you specify gradient, is better specify hessian also.')
                    GetSymbolicalGradient(obj);
                end
                GetSymbolicalHessian(obj);
            end

            %% Calculate Adjoint of Dynamics
            if isempty(Adjoint)
                GetSymbolicalAdjointProblem(obj);
            else
                obj.adjoint.dynamics = Adjoint;
            end
            %% Calculate Adjoint of Dynamics
            if isempty(AdjointFinalCondition)
                GetSymbolicalAdjointFinalCondition(obj);
            else
                obj.adjoint.FinalCondition.Numeric = AdjointFinalCondition;
            end
        end
        
    end
end

