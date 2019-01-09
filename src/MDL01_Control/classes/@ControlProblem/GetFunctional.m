function Jvalue = GetFunctional(iControlProblem,Y,U)
% description: Metodo de Es
% autor: Xinlung
% MandatoryInputs:   
%  iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
%  U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tline)]
%    default:   empty
% Outputs:
%  U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tline)]
%    default:   empty

    tline   = iControlProblem.ode.tline;
    L       = iControlProblem.Jfun.numL;
    Psi     = iControlProblem.Jfun.numPsi;
    
    Yfun = @(t) interp1(tline,Y,t,'nearest');
    Ufun = @(t) interp1(tline,U,t,'nearest');

    Lvalues = arrayfun(@(t)  L(t,Yfun(t)',Ufun(t)),tline);
    
    Larea   = trapz(tline,Lvalues);
    %        % 
    T = tline(end);
    Jvalue = Larea + Psi(T,Yfun(T));
end



