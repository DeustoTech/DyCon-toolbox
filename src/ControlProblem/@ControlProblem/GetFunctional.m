function Jvalue = GetFunctional(iControlProblem,Y,U)
%GETFUNCTIONAL Summary of this function goes here
%   Detailed explanation goes here

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

