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
%    defa,ult:   empty

ax = axes;

struct = [iode.VectorState];
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
