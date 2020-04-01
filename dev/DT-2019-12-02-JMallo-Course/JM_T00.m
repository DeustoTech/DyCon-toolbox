load MultidomainMesh2D
elements()
%% 
nodes
clf
plot(nodes(1,:),nodes(2,:),'+')
%%
clc
size(elements)
elements = elements(1:3,:);
%%
model = createpde;
[G,M] = geometryFromMesh(model,nodes,elements,ElementIdToRegionId);
%%
pdemesh(model)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
model = createpde;

R1 = [3,4, ... % [ tipo  numeroDeSegmentos ]
      -1, 1, ... % points
       1,-1, ...
       1, 1, ...
      -1,-1]'; 
%  
C1 = [1,+0.0,-0.5,0.25]';  % [ tipo circulo - Xpos - Ypos - Radio]
%
C1 = [C1;zeros(length(R1) - length(C1),1)];
%
E1 = [4 0 0.4  0.2 0.4 0.25*pi ]'; % [ tipo elipse - x - y - rx - ry - angle ]
%
E1 = [E1;zeros(length(R1) - length(E1),1)];

%%%%%%

gm = [R1,C1,E1];
sf = 'R1+E1-C1';
%
ns = char('R1','C1','E1');
ns = ns';
g = decsg(gm,sf,ns);
%
geometryFromEdges(model,g);
pdegplot(model,'EdgeLabels','on')
axis equal
xlim([-1.1,1.1])

%%
mesh = generateMesh(model);
pdemesh(model)