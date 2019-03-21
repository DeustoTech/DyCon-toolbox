  function GetSymbolicalAdjointFinalCondition(obj)
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

    Jfun   = obj.J;
    iode   = obj.ode;
    symPsi = Jfun.Psi.Symbolic;
    %% Creamos las variables simbolica 
    symY   = iode.StateVector.Symbolic;
    t      = iode.symt;
    symP  =  sym('p', [1 length(symY)]);
    
    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    PT = gradient(formula(symPsi),symY.').';
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  y1,...,yn)
    obj.adjoint.FinalCondition.Symbolic  = symfun(PT,[t symY.']);
    % Pasamos esta funcion a una function_handle
    obj.adjoint.FinalCondition.Numeric = matlabFunction(PT,'Vars',{t,symY});
  
    obj.adjoint.P = symP;

  end
  
  