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
        function obj = Pontryagin(idynamics,Psi,L,varargin)
        % name: ControlProblem
        % description: 
        % autor: JOroya
        % MandatoryInputs:   
        %   idynamics: 
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
        %       default: idynamics.T 
        %   dt:
        %       name: Final Time 
        %       description: This parameter represent is the interval to interpolate the control, $u$, and state, $y$, to obtain the functional $J$ and the gradient $dH/du$
        %       class: double
        %       dimension: [1x1]
        %       default: idynamics.dt         
        % Outputs:
        %   obj:
        %       name: ControlProblem MATLAB
        %       description: ControlProblem MATLAB class
        %       class: ControlProblem
        %       dimension: [1x1]

            p = inputParser;
            
            addRequired(p,'idynamics');
            
            addRequired(p,'Psi',@ValidatorPontryaginPsi);
            addRequired(p,'L'  ,@ValidatorPontryaginL);
                    
            addOptional(p,'DiffLagrangeState',[],@(dPsidY)ValidatorPontryaginDiffLagrangeState(idynamics,dPsidY))
            addOptional(p,'DiffLagrangeControl',[],@(dPsidY)ValidatorPontryaginDifLagrangeControl(idynamics,dPsidY))
            
            addOptional(p,'DiffFinalCostState',[],@(dPsidY)ValidatorPontryaginDiffFinalCostState(idynamics,dPsidY))
            addOptional(p,'Adjoint',[])
            addOptional(p,'CheckDerivatives',false)

            
            parse(p,idynamics,Psi,L,varargin{:})
            
            DiffLagrangeState   = p.Results.DiffLagrangeState;
            DiffLagrangeControl = p.Results.DiffLagrangeControl;
            DiffFinalCostState  = p.Results.DiffFinalCostState;
            
            Adjoint             = p.Results.Adjoint;
            
            CheckDerivatives = p.Results.CheckDerivatives;
            
            t        = idynamics.symt;
            U        = idynamics.Control.Symbolic;
            Y        = idynamics.StateVector.Symbolic;

            %% Test Variables
            Utest001 = zeros(idynamics.ControlDimension,1);
            Ytest001 = zeros(idynamics.StateDimension,1);
            time0001 = 0;
            %% Dynamics Definition                   
            obj.Dynamics                 = copy(idynamics);
            
            %% Derivative Dynamics
            if isempty(obj.Dynamics.DerivativeDynControl.Numerical)
                GetSymbolicalDerivativeControl(obj.Dynamics)
            end
            
            if isempty(obj.Dynamics.DerivativeDynState.Numerical)
                GetSymbolicalDerivativeState(obj.Dynamics)
            end
            %% Terminal Cost Term
            obj.Functional.Psi.Numeric       = Psi;
            if isempty(DiffFinalCostState)||CheckDerivatives
                obj.Functional.Psi.Symbolic   = symfun(Psi(t,Y),[t,Y.']);
                dPsidYSym = gradient(obj.Functional.Psi.Symbolic,Y.').';
                dPsidYNum =  matlabFunction(dPsidYSym,'Vars',{t,Y});
                %
                if ~isempty(DiffFinalCostState)
                    % check Psi_y 
                    symResult = dPsidYNum(time0001,Ytest001);
                    numResult = DiffFinalCostState(time0001,Ytest001);
                    %
                    if max(abs(symResult - numResult)) < 1e-3 
                        fprintf(['   - The dPsi/dY is equal to symbolic derivation',newline,newline])
                    else
                        error('The dPsi/dY is different to symbolic derivation')
                    end
                end
                obj.Functional.DiffPsiState.Symbolic  = dPsidYSym;
                obj.Functional.DiffPsiState.Numeric   = dPsidYNum;
                
            else
                obj.Functional.DiffPsiState.Symbolic  = sym.empty;
                obj.Functional.DiffPsiState.Numeric   = DiffFinalCostState;
            end
            
            %% Lagrange Term

            obj.Functional.L.Numeric     = L;
            % si alguno no esta dado, hay que calcularlo
            if isempty(DiffLagrangeState)||isempty(DiffLagrangeControl) || CheckDerivatives
                obj.Functional.L.Symbolic    = symfun(L(t,Y,U),[t,Y.',U.']);
            end
            %% Lagrange Term - State Derivative
            if isempty(DiffLagrangeState)||CheckDerivatives
                dLdYsym =  gradient(obj.Functional.L.Symbolic,Y.');
                dLdYnum =  matlabFunction(dLdYsym,'Vars',{t,Y,U});
                
                if ~isempty(DiffLagrangeState)
                    symResult = dLdYnum(time0001,Ytest001,Utest001);
                    numResult = DiffLagrangeState(time0001,Ytest001,Utest001);
                    %
                    if max(abs(symResult - numResult)) < 1e-3 
                        fprintf(['  - The dL/dY is equal to symbolic derivation',newline,newline])
                    else
                        error('The dL/dY is different to symbolic derivation')
                    end
                end
                obj.Functional.DiffLState.Symbolic   = dLdYsym;
                obj.Functional.DiffLState.Numeric    = dLdYnum;
            else
                obj.Functional.DiffLState.Symbolic  = sym.empty;
                obj.Functional.DiffLState.Numeric    = DiffLagrangeState;
            end
            
            %% Lagrange Term - Control Derivative
            if isempty(DiffLagrangeControl) || CheckDerivatives
                dLdUsym =  gradient(obj.Functional.L.Symbolic,U.');
                dLdUnum = matlabFunction(dLdUsym,'Vars',{t,Y,U});            %% Hamiltonian
                if ~isempty(DiffLagrangeControl)
                    symResult = dLdUnum(time0001,Ytest001,Utest001);
                    numResult = DiffLagrangeControl(time0001,Ytest001,Utest001);
                    %
                    if max(abs(symResult - numResult)) < 1e-3 
                        fprintf(['  - The dL/dU is equal to symbolic derivation',newline,newline])
                    else
                        error('The dL/dU is different to symbolic derivation')
                    end
                end
                obj.Functional.DiffLControl.Symbolic   = dLdUsym;
                obj.Functional.DiffLControl.Numeric    = dLdUnum;
            else
                obj.Functional.DiffLControl.Numeric    = DiffLagrangeControl;
            end
            
            dLdUnum = obj.Functional.DiffLControl.Numeric;
            %% Crear funciones Generales para los algorimtos de optimizacion
            dFdUnum = obj.Dynamics.DerivativeDynControl.Numerical;
            obj.ControlGradient.Numerical = @(t,Y,P,U) obj.Dynamics.dt*(dLdUnum(t,Y,U) + dFdUnum(t,Y,U).'*P);
            % Adjoint
            if isempty(Adjoint)
                GetSymbolicalAdjointProblem(obj);
            else
                obj.Adjoint.Dynamics = Adjoint;
            end
            
            obj.Adjoint.FinalCondition.Numeric   =  obj.Functional.DiffPsiState.Numeric;
            obj.Adjoint.FinalCondition.Symbolic =   obj.Functional.DiffPsiState.Symbolic;
    
          end
        
    end
end

