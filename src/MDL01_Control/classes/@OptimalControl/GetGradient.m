function GetGradient(iP)
% description: Creates the iCP.dH_du property that contains a numeric function that 
%               returns the value of the gradient given the dynamics solution, 
%               $Y$ and the associated control, $U$.
% little_description: Creates the iCP.dH_du property that contains a numeric function that 
%               returns the value of the gradient given the dynamics solution, 
%               $Y$ and the associated control, $U$. 
% autor: JOroya
% MandatoryInputs:   
%  iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
    syms t
    %%
    iode   = iP.ode;
    symL   = iP.J.L.Symbolic; 
    %% Creamos las variables simbolica 
    symU   = iode.Control.Symbolic;
    % Obtenemos el vector Symbolico Y = [y1 y2 y3 ...]^T
    symY   = iode.VectorState.Symbolic;
    % Creamos el vector Symbolico   P = [p1 p2 p3 ...]
    
    symP  =  sym('p', [length(symY),1]);
    %if ~iP.ode.lineal    
        iP.hamiltonian = symL + symP.'*formula(iP.ode.Dynamic.Symbolic);
    %else
        %iP.hamiltonian = symL + symP.'*(iP.ode.A* iP.ode.VectorState.Symbolic + iP.ode.B*iP.ode.Control.Symbolic);
    %end
    % Para cada cordenada de U, calculamos la derivada de dH/du_i
    dH_du = arrayfun(@(u) diff(formula(iP.hamiltonian),u), symU.');
    %
    iP.gradient.sym = symfun(dH_du,[t symY.' symP.' symU.']);
    % Pasamos esta funcion a una function_handle
    iP.gradient.num = matlabFunction(dH_du,'Vars',{t,symY,symP,symU});
            

end
