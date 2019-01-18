function GetGradient(iControlProblem)
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


    syms Hamil t u 
    %%
    Jfun   = iControlProblem.Jfun;
    iode   = iControlProblem.ode;
    
    symL   = Jfun.symL; 
    symF   = iode.symF;
    %% Creamos las variables simbolica 
    symU   = iode.symU;
    % Obtenemos el vector Symbolico Y = [y1 y2 y3 ...]^T
    symY   = iode.symY;
    % Creamos el vector Symbolico   P = [p1 p2 p3 ...]
    symP   = iControlProblem.P;
    
    %% Hamiltoniano
    Hamil = symL + symP*symF;
    
    %% Direccion del Gradiente
    % Para cada cordenada de U, calculamos la derivada de dH/du_i
    dH_du = arrayfun(@(us) diff(formula(Hamil),us), symU.');
    dH_du = symfun(dH_du,[t symY.' symP symU.']);
    % Pasamos esta funcion a una function_handle
    dH_du = matlabFunction(dH_du);
    % Por ultimo vectorizamos la function handle 
    %
    % dH_du (t,Y,P,U)    
    % donde Y = [y1 y2 ...], 
    %       U = [u1 u2 ...], 
    %       P = [p1 p2 ...]
    
    iControlProblem.dH_du = VectorialForm(dH_du,[t,symY.',symP,symU.'],'(t,Y,P,U)');

end
