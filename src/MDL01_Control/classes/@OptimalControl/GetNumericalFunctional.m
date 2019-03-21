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

    %p = parse()
    %addRequired(p,'iCP')
    
    
    tspan   = iCP.ode.tspan;
    L       = iCP.J.L.Numeric;
    Psi     = iCP.J.Psi.Numeric;

    Lvalues = arrayfun(@(index)  L(tspan(index),Y(index,:)',U(index,:)'),1:length(tspan));

    Jvalue = trapz(tspan,Lvalues) + Psi(tspan(end),Y(end,:)');
end



