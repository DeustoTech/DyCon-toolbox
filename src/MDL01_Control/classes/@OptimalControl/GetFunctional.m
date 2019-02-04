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

    tspan   = iCP.ode.tspan;
    L       = iCP.J.L.Numeric;
    Psi     = iCP.J.Psi.Numeric;
    
    Yfun = @(t) interp1(tspan,Y,t);
    Ufun = @(t) interp1(tspan,U,t);

    Lvalues = arrayfun(@(t)  L(t,Yfun(t)',Ufun(t)'),tspan);

    Larea   = trapz(tspan,Lvalues);
    %        % 
    T = tspan(end);
    Jvalue = Larea + Psi(T,Yfun(T)');
end



