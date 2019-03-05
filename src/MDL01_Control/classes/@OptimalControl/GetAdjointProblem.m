  function GetAdjointProblem(obj)
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

    if obj.ode.lineal
        LinealAdjoint(obj)
    else
        NonLinealAdjoint(obj)
    end
  end
  
  
%%
  function LinealAdjoint(obj)
    Jfun   = obj.J;
    iode   = obj.ode;
    symPsi = Jfun.Psi.Symbolic;
    %% Creamos las variables simbolica 
    symU   = iode.Control.Symbolic;
    symY   = iode.StateVector.Symbolic;
    t      = iode.symt;
    symP  =  sym('p', [1 length(symY)]);
    
    %% Hamiltoniano
    if  double(sum(gradient(obj.J.L.Symbolic,obj.ode.StateVector.Symbolic.'))) == 0
        % dL/dy = 0, el problema adjunto es independiente del control y del
        % estado
        obj.adjoint.ode = ode('A',obj.ode.A.');
            
    else
        L = obj.J.L.Symbolic;
        dP_dt = arrayfun( @(xs) -diff(formula(L),xs), symY.');
        % Convertimos la expresion a una funcion simbolica
        % dP_dt(t,  x1,...,xn,  u1,...,um,  p1,...,pn)
        Control = [symY.' symU.'].';
        State   = [symP].';
        obj.adjoint.ode = ode(dP_dt,State,Control); 
    end

    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    PT = arrayfun(@(ys) diff(formula(symPsi),ys), symY.');
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  y1,...,yn)
    obj.adjoint.FinalCondition.Symbolic  = symfun(PT,[t symY.']);
    % Pasamos esta funcion a una function_handle
    obj.adjoint.FinalCondition.Numeric = matlabFunction(PT,'Vars',{t,symY});
  
    obj.adjoint.P = symP;
  end
  
  function NonLinealAdjoint(obj)
      %%
    Jfun   = obj.J;
    iode   = obj.ode;
    symPsi = Jfun.Psi.Symbolic;
    %% Creamos las variables simbolica 
    symU   = iode.Control.Symbolic;
    symY   = iode.StateVector.Symbolic;
    t      = iode.symt;
    symP  =  sym('p', [1 length(symY)]);
    
    %% Hamiltoniano
    L = obj.J.L.Symbolic;
    %% Obtenemos el Adjunto
    % Creamos el problema adjunto  en simbolico
    dP_dt = arrayfun( @(xs) -diff(formula(L),xs), symY.');
    % Convertimos la expresion a una funcion simbolica
    % dP_dt(t,  x1,...,xn,  u1,...,um,  p1,...,pn)
    Control = [symY.' symU.'].';
    State   = [symP].';
    obj.adjoint.ode = ode(dP_dt,State,Control);
    % Pasamos esta funcion a una function_handle

    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    PT = arrayfun(@(ys) diff(formula(symPsi),ys), symY.');
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  y1,...,yn)
    obj.adjoint.FinalCondition.Symbolic  = symfun(PT,[t symY.']);
    % Pasamos esta funcion a una function_handle
    obj.adjoint.FinalCondition.Numeric = matlabFunction(PT,'Vars',{t,symY});
  
    obj.adjoint.P = symP;

  end
