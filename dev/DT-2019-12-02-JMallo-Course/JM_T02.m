clear all
%% Create PDE Model
% Create a PDE Model with a single dependent variable.
numberOfPDE = 1;
model = createpde(numberOfPDE);
%% Geometry Definition
% Convert the geometry and append it to the pde model.
g = @scatterg;
geometryFromEdges(model,g);
% Plot the geometry and display the edge labels for use in the boundary
% condition definition.
%%
figure; 
pdegplot(model,'EdgeLabels','on'); 
axis equal
title 'Geometry With Edge Labels Displayed';
ylim([0,1])

%% PDE Definition
fFcn = @(x,y) 50*exp(-(x-0.8).^2/0.1 - (y-0.5).^2/0.1) ;
specifyCoefficients(model,'m',0,'d',1,'c',1,'a',0,'f',@(l,s) fFcn(l.x,l.y) )
% Apply the boundary conditions.
bOuter = applyBoundaryCondition(model,'dirichlet','Edge',(5:8),'u',0);
bInner = applyBoundaryCondition(model,'dirichlet','Edge',(1:4),'u',-3);
%% Create Mesh
mesh = generateMesh(model,'Hmax',0.1,'GeometricOrder','linear');
figure
pdemesh(model); 
axis equal
%%
fnum = fFcn(mesh.Nodes(1,:),mesh.Nodes(2,:));
trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :),fnum, 'facecolor', 'interp');

%%
FEM = assembleFEMatrices(model,'stiff-spring');
%%
A =  FEM.M\FEM.Ks;
ICFcn = @(x,y)10*sin((x-0.8).*(y-0.5));
Y0 = ICFcn(mesh.Nodes(1,:),mesh.Nodes(2,:))';
%%
[N,~] = size(A);
tspan = linspace(0,1,N);
[~,FreeState] = ode23tb(@(t,Y) - (FEM.M\FEM.Ks)*Y +(FEM.M\FEM.Fs),tspan,Y0) ;
FreeState = FreeState';
%
%% Optimal Control 
import casadi.*

Us = SX.sym('x',N,1);
Fs = SX.sym('u',N,1);
ts = SX.sym('t');
%

B = eye(N);
EvolutionFcn = Function('f',{ts,Us,Fs},{ - (FEM.M\FEM.Ks)*Us +  FEM.Fs +B*Fs });
%
idyn = ode(EvolutionFcn,Us,Fs,tspan);
idyn.InitialCondition = Y0;
%
epsilon = 1e5;
PathCost  = Function('L'  ,{ts,Us,Fs},{ Fs'*Fs           });
FinalCost = Function('Psi',{Us}      ,{ epsilon*(Us'*Us) });

iocp = ocp(idyn,PathCost,FinalCost);

%%
U0 = ZerosControl(idyn);
U0 = U0(:,1:end-1);
[OptControl ,OptState] = IpoptSolver(iocp,U0);

%%
close all
figure('unit','norm','pos',[0 0 1 1])
ax1 = subplot(1,3,1); view(ax1,-20,10);
ax2 = subplot(1,3,2); view(ax2,-20,10);
ax3 = subplot(1,3,3); view(ax3,-20,10);
%
for it = 1:length(tspan)-1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y = OptState(:,it);
    trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :), y, 'facecolor', 'interp','Parent',ax1);
    caxis(ax1,[-0.5 0.5])
    zlim(ax1,[-4 4]) 
    title(ax1,'Dynamic with Control')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y = OptControl(:,it);
    trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :), y, 'facecolor', 'interp','Parent',ax2);
    caxis(ax2,[-0.5 0.5])
    zlim(ax2,[-4 4]) 
    title(ax2,'Control')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    y = FreeState(:,it);
    trisurf(mesh.Elements', mesh.Nodes(1, :), mesh.Nodes(2, :), y, 'facecolor', 'interp','Parent',ax3);
    caxis(ax3,[-0.5 0.5])
    zlim(ax3,[-4 4]) 
    title(ax3,'Free Dynamic')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pause(0.01) 
    
end
