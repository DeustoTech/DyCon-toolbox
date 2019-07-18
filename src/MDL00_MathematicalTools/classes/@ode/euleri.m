function [tspan, sol] = euleri(iode,varargin)
% description: The ode class, if only de organization of ode.
%               The solve of this class is the RK family.
% autor: JOroya
% OptionalInputs:
%   DynamicEquation: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   StateVector: 
%       description: StateVector
%       class: Symbolic
%       dimension: [1x1]
%   Control: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   A: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]
%   B: 
%       description: simbolic expresion
%       class: matrix
%       dimension: [1x1]            
%   InitialControl:
%       name: Initial Control 
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tspan)]
%       default:   empty       
    if ~iode.lineal
       error('This ode can not solve by euleri because it is not lineal') 
    end
    %%
    A                = iode.A;
    B                = iode.B;
    M                = iode.MassMatrix;
    InitialCondition = iode.InitialCondition;
    U                = iode.Control.Numeric;
    
    tspan = iode.tspan;

    [N,~] = size(A);
    StepsTime = length(tspan);
    sol = zeros(N,StepsTime);
    sol(:,1) = InitialCondition;
    
    %% NO ESTA PENSADO PARA TSPAN NO UNIFORME
    dt = tspan(2) - tspan(1);
    C=speye(N,N)-dt*(M\A);

    if ~isempty(B)

        for i=2:StepsTime
            sol(:,i) = C\(sol(:,i-1) + dt*( B*U(i-1,:)'));
        end
    
    else
        
        for i=2:StepsTime
            sol(:,i) = C\sol(:,i-1);
        end
        
    end
    sol = sol';
    
end