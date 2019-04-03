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

    xline = iCP.dynamics.xline;
    tspan = iCP.dynamics.tspan;
    s     = iCP.s;
    k     = iCP.kappa;
    YT    = iCP.YT;
    
    if s == Inf
        dY = Y(end,:).'-YT;
        dY_norm_L2 = trapz(xline,abs(dY.').^2);
        
         J = 0.5*max(max(U))^2 + 0.5*k*dY_norm_L2;
    else
        
        U_norm_Ls = trapz(tspan,trapz(xline,abs(U.').^s));
        U_norm_Ls = U_norm_Ls.^(1/s);

        dY = Y(end,:).'-YT;
        dY_norm_L2 = trapz(xline,abs(dY.').^2);

        J = 0.5*U_norm_Ls^2 + 0.5*k*dY_norm_L2;
    end
    
end



