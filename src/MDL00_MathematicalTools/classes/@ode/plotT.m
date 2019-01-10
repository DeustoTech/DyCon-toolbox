function plotT(iode)
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
% iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
% U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tline)]
%    default:   empty

ax = axes
Y = iode.Y;
[nrow ncol] = size(Y);

line(1:ncol, Y(end,:),'Parent',ax,'Marker','*','LineStyle','-');

        
end

