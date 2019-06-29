classdef (Abstract) AbstractOptimalControl  < handle & matlab.mixin.SetGet & matlab.mixin.Copyable
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
%                   <li>  <a href='https://deustotech.github.io/dycon-toolbox-documentation/documentation/mdl01/optimalcontrol/ClassicalDescent'>Classical gradient method</a></li>
%                   <li>  <a href='https://deustotech.github.io/dycon-toolbox-documentation/documentation/mdl01/optimalcontrol/AdaptativeDescent'>Gradient method with adaptive descend step</a></li>
%                   <li>  <a href='https://deustotech.github.io/dycon-toolbox-documentation/documentation/mdl01/optimalcontrol/ConjugateGradientDescent'>Conjugate gradient method</a></li>
%                 </ul>
    properties 
        % type: "Functional"methods (Abstract)

        % default: "none"
        % description: "This property represent the cost of optimal control"
        Functional        
        % type: ode
        % default: none
        % description: This property represented ordinary differential equation
        Dynamics        
        % type: double
        % default: function_handle
        % description: The derivative of the Hamiltonian with respect to the control u 
        Adjoint        
        % type: double
        % default: function_handle
        % description: The derivative of the Hamiltonian with respect to the control u 
        Hamiltonian     
        % type: struct
        % default: none
        % description: The adjoint propertir contain the numerical function that represents the adjoint problem this struct have a two properties. The first is dP_dt and the second is P0.   
        ControlGradient             SymNumFun       = SymNumFun
        % type: struct
        % default: none
        % description: The adjoint propertir contain the numerical function that represents the adjoint problem this struct have a two properties. The first is dP_dt and the second is P0. 
        Hessian                     SymNumFun       = SymNumFun
        % type: double
        % default: none
        % description: It is an array that contains the different functional values during the execution of the optimization algorithm that has been used.
        Adjoint2Control             SymNumFun       = SymNumFun
        Solution
        %
        Constraints                 constraints     = constraints
    end
    
    properties (Hidden)
        tempdata
    end
    methods (Abstract)
         Y  = GetNumericalDynamics(iCP,Control)
         dJ = GetNumericalControlGradient(iCP,U,Y,P)
         P  = GetNumericalAdjoint(iCP,U,Y)
         J  = GetNumericalFunctional(iCP,Y,U)
         PT = GetNumericalAdjointFinalCondition(iCP,Y)
    end
     
end

