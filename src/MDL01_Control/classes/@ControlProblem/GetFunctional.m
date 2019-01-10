function Jvalue = GetFunctional(iCP,Y,U)
% description: Method capable of calculating the value of the functional defined in the control problem.
% little_description: Method capable of calculating the value of the functional defined in the control problem.
% autor: JOroya
% MandatoryInputs:   
%  iCP: 
%    description:  Control Problem
%    class: ControlProblem
%    dimension: [1x1]
%  Y: 
%    name: Solution of ODE
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
%  U: 
%    name: matrix of control
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% Outputs:
%  JValue:
%    name: Functional value with this U and Y 
%    description: double 
%    class: double
%    dimension: [1x1]

    tline   = iCP.ode.tline;
    L       = iCP.Jfun.numL;
    Psi     = iCP.Jfun.numPsi;
    
    Yfun = @(t) interp1(tline,Y,t,'nearest');
    Ufun = @(t) interp1(tline,U,t,'nearest');

    Lvalues = arrayfun(@(t)  L(t,Yfun(t)',Ufun(t)),tline);
    
    Larea   = trapz(tline,Lvalues);
    %        % 
    T = tline(end);
    Jvalue = Larea + Psi(T,Yfun(T));
end



