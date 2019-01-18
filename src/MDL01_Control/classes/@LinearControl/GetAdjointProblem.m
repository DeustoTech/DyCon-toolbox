  function GetAdjointProblem(iControlProblem)
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

    %%
    syms t 
    
    Jfun   = iControlProblem.Jfun;
    iode   = iControlProblem.ode;
    
    symPsi = Jfun.symPsi;
    %% Creamos las variables simbolica 
    % Creamos el vector Symbolico Y = [y1 y2 y3 ...]^T
    [dim , ~] = size(iode.A);
    
    symY = SymsVector('y',dim);
    iode.symY = symY;
    symP = SymsVector('p',dim);
    iControlProblem.P = symP.';    
    %
    iControlProblem.adjoint.dP_dt = @(t,P,Y,U) (iControlProblem.ode.A'*P)';
    %% Condicion inicial del problema adjunto
    % Para cada cordenada de X, calculamos la derivada de dPsi/dx_i
    P0 = arrayfun(@(ys) diff(formula(symPsi),ys), symY.');
    % Convertimos la expresion a una funcion simbolica
    % P0(t,  y1,...,yn)
    P0 = symfun(P0,[t symY.']);
    % Pasamos esta funcion a una function_handle
    P0 = matlabFunction(P0);
    % Por ultimo vectorizamos la function handle 
    %
    % P0 (t,Y) 
    % donde Y = [y1 y2 ...], 
    %
    iControlProblem.adjoint.P0 = VectorialForm(P0,[t symY.'],'(t,Y)');
    % 
end
