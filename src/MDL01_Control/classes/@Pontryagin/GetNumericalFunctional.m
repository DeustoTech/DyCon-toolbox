function Jvalue = GetNumericalFunctional(iCP,Y,U)
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

    
    tspan   = iCP.Dynamics.tspan;
    L       = iCP.Functional.Lagrange.Num;
    Psi     = iCP.Functional.TerminalCost.Num;
    Nt      = iCP.Dynamics.Nt;
    dt      = iCP.Dynamics.dt;

    Lvalues = arrayfun(@(index)  L(tspan(index),Y(index,:)',U(index,:)'),1:(Nt-1));
    Jvalue = sum(Lvalues)*dt +  Psi(tspan(end),Y(end,:)');

    %Jvalue = trapz(tspan,Lvalues) + Psi(tspan(end),Y(end,:)');

end



