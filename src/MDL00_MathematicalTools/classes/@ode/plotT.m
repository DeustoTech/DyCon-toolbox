function plotT(iode)
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

ax = axes;

struct = [iode.StateVector];
Y = {struct.Numeric};
[nrow ncol] = size(Y{1});


colors = {'r','g','b'};
LinS = {'-','--'};
pt = {'*','s'};
index = 0;
for iY = Y
    index = index + 1;
    ic = mod(index,3) + 1;
    il = mod(index,2) + 1;
    ip = mod(index,2) + 1;
    line(1:ncol, iY{:}(end,:),'Parent',ax,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic});
end
legend({iode.label})
