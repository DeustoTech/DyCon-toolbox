function resume(idynamics)
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
tab = '     ';


condition = 'Y(0) = ';


display([newline, ...
         tab,'Dynamics:',newline,newline, ...
         tab,tab,'Y''(t,Y,U) = ',char(idynamics.DynamicEquation.Num), ...
         newline,newline, ...
         tab,tab,'t in [0,',num2str(idynamics.FinalTime),']  with condition: ',condition,char(join(string(idynamics.InitialCondition),' ')),newline])
         
end

