  function GetSymbolicalAdjointProblem(obj)
% description: This method adds the problem adjoint to the Control Problem object, since we have
%               $$ \\dot{\\textbf{Y}} = f(\\textbf{Y},t) $$ 
%               and the functional
%               $$ J = \\Psi(\\textbf{Y}(T)) + \\int_{0}^T L(\\textbf{Y},U,t)dt $$ 
%               we can create the Hamiltonian 
%               $$ H = L + P*F $$
%               where $\\textbf{P} = [p_1 p_2 p_3 ... ]^T$ . So according to the principle of the maximum of pontriagin,
%               we can calculate the attached problems through the formulas
%               $$ \\frac{d\\textbf{P}}{dt} = \\vec{\\nabla}_{Y} H = 
%               (\\frac{\\partial H}{ \\partial y_1},\\frac{\\partial H}{ \\partial y_2},...)$$
%               with the final time condition
%               $$ \\textbf{P}(T) = 
%               (\\frac{\\partial \\Psi}{ \\partial y_1},\\frac{\\partial \\Psi}{ \\partial y_2},...)$$
% little_description: Method capable of obtaining the attached problem and its final condition.
% autor: JOroya
% MandatoryInputs:   
%    iCP: 
%        name: Control Problem
%        description: Control problem object
%        class: ControlProblem
%        dimension: [1x1]

    Jfun   = obj.Functional;
    iode   = obj.Dynamics;
    L      = Jfun.Lagrange.Sym;
    %% Creamos las variables simbolica 
    symU   = iode.Control.Symbolic;
    symY   = iode.StateVector.Symbolic;
    symP  =  sym('p', [length(symY) 1]);
    
    lineal = false;
    if obj.Dynamics.lineal
        Lu = obj.Functional.LagrangeDerivatives.State.Sym;
        if  sum(Lu) == sym(0)
            obj.Adjoint.Dynamics = ode('A',iode.A);
            lineal = true;
        end
    end
    
    if ~lineal
        %% Obtenemos el Adjunto
        FY = obj.Dynamics.Derivatives.State.Num;
        LY = obj.Functional.LagrangeDerivatives.State.Num;
        % Creamos el problema adjunto  en simbolico
        Sdim = obj.Dynamics.StateDimension;
        dP_dt = @(t,P,YU,Params) FY(t,YU(1:Sdim),YU(Sdim+1:end))'*P + LY(t,YU(1:Sdim),YU(Sdim+1:end));  
        % Convertimos la expresion a una funcion simbolica
        % dP_dt(t,  x1,...,xn,  u1,...,um,  p1,...,pn)
        Control = [symY; symU];
        State   = symP;
        Params  = obj.Dynamics.Params;
        obj.Adjoint.Dynamics = ode(dP_dt,State,Control,Params);
        obj.Adjoint.Dynamics.Solver = obj.Dynamics.Solver;

        % Pasamos esta funcion a una function_handle
    end



  end
  
  