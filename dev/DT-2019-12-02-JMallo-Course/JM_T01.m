clear all
%% Create PDE Model
% Create a PDE Model with a single dependent variable.
numberOfPDE = 1;
model = createpde(1);
%% Geometry Definition
% Convert the geometry and append it to the pde model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g = @scatterg;
geometryFromEdges(model,g);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clf; 
pdegplot(model,'EdgeLabels','on'); 
axis equal
title 'Geometry With Edge Labels Displayed';
%% Create Mesh
mesh = generateMesh(model,'Hmax',0.08,'GeometricOrder','linear');
clf
pdemesh(model); 
axis equal
%% PDE Definition
% initial Condition
fFcn = @(x,y)10*sin((x-0.8).*(y-0.5));
Y0 = fFcn(mesh.Nodes(1,:),mesh.Nodes(2,:));
trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :),Y0, 'facecolor', 'interp');
% Dynamics equation
specifyCoefficients(model,'m',0,'d',1,'c',1,'a',0,'f',@(l,s) fFcn(l.x,l.y)  )
% boundary conditions.
bOuter = applyBoundaryCondition(model,'dirichlet','Edge',(5:8),'u',0);
bInner = applyBoundaryCondition(model,'dirichlet','Edge',(1:4),'u',-3e-2);

%% Matrices
FEM = assembleFEMatrices(model,'stiff-spring');
%%
A =  FEM.M\FEM.Ks;
tspan = linspace(0,2,50);
[~,Yt] = ode23tb(@(t,Y) -A*Y + FEM.Fs,tspan,Y0) ;

%%
set(gcf, 'color', 'w')
for y = Yt'
    cla
    trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :), y, 'facecolor', 'interp');
    caxis([-0.5 0.5])
    zlim([-2 2])
    set(gca, 'Projection', 'perspective')
    drawnow    
end
%%
