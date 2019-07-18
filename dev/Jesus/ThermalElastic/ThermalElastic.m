clear 
structuralmodel = createpde(2);
%% 
% Create a beam geometry with the following dimensions.

L = 0.1; % m
W = 5E-3; % m
H = 1E-3; % m
gm = multicuboid(L,W,H);
%% 
% Include the geometry in the structural model.

structuralmodel.Geometry = gm;

%% 
% Assign the material properties of invar to the top cell.

Ei = 130E9; % N/m^2
nui = 0.354;
CTEi = 1.2E-6; % m/m-C
generateMesh(structuralmodel,'Hmax',0.25);

pdemesh(structuralmodel)

specifyCoefficients(structuralmodel,  'm',ones(4,1),...
                                      'd',eye(140),...
                                      'c',ones(4,1),...
                                      'a',ones(4,1), ...
                                      'f',1e5*ones(4,1));
                                  
setInitialConditions(structuralmodel, [2 2 2 2]')
structuralmodel.InitialConditions.InitialConditionAssignments.InitialDerivative = [2 2 2 2]';

applyBoundaryCondition(structuralmodel,'dirichlet','Face',1:6)
tspan = 0:0.1:2;
results = solvepde(structuralmodel,tspan);
%%
len =  results.NodalSolution;
%
dfor.ux = 1e8*results.NodalSolution(:,2,1);
%dfor.uy = 1e8*results.NodalSolution(:,3,1);
dfor.uz = 1e8*results.NodalSolution(:,4,1);
dfor.Magnitude = sqrt(dfor.ux.^2 + dfor.uy.^2 + dfor.uz.^2);
close all
pdeplot3D(structuralmodel,'ColorMapData',results.NodalSolution(:,1,1),'Deformation',dfor,'DeformationScaleFactor',100,'FaceAlpha',0.3)


function f = fcoeffunction(p,t,u,time)
N = 3; % Number of equations
% Triangle point indices
it1 = t(1,:);
it2 = t(2,:);
it3 = t(3,:);
% Find centroids of triangles
xpts = (p(1,it1) + p(1,it2) + p(1,it3))/3;
ypts = (p(2,it1) + p(2,it2) + p(2,it3))/3;
[ux,uy] = pdegrad(p,t,u); % Approximate derivatives
uintrp = pdeintrp(p,t,u); % Interpolated values at centroids
nt = size(t,2); % Number of columns
f = zeros(N,nt); % Allocate f
% Now the particular functional form of f
f(1,:) = xpts - ypts + uintrp(1,:);
f(2,:) = 1 + tanh(ux(1,:)) + tanh(uy(3,:));
f(3,:) = (5 + uintrp(3,:)).*sqrt(xpts.^2 + ypts.^2);
end