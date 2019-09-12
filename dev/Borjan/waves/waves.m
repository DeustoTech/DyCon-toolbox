%% Wave Equation on Square Domain
% This example shows how to solve the wave equation using the |solvepde|
% function.

% Copyright 1994-2015 The MathWorks, Inc.
%% Problem Definition
%
% The standard second-order wave equation is
% 
% $$ \frac{\partial^2 u}{\partial t^2} - \nabla\cdot\nabla u = 0.$$
%
% To express this in toolbox form, note that the |solvepde| function
% solves problems of the form
%
% $$ m\frac{\partial^2 u}{\partial t^2} - \nabla\cdot(c\nabla u) + au =
% f.$$
%
% So the standard wave equation has coefficients $m = 1$, $c = 1$, $a = 0$,
% and $f = 0$.
c = 1;
a = 0;
f = 0;
m = 1;

%% Geometry
% Solve the problem on a square domain. The |squareg| function describes
% this geometry. Create a |model| object and include the geometry. Plot the
% geometry and view the edge labels.
numberOfPDE = 1;
model = createpde(numberOfPDE);
geometryFromEdges(model,@squareg);
pdegplot(model,'EdgeLabels','on'); 
ylim([-1.1 1.1]);
axis equal
title 'Geometry With Edge Labels Displayed';
xlabel x
ylabel y

%% Specify PDE Coefficients
specifyCoefficients(model,'m',0,'d',1,'c',c,'a',a,'f',@fsource);

%% Boundary Conditions
applyBoundaryCondition(model,'neumann','Edge',([1 2 3 4]),'g',0);
%applyBoundaryCondition(model,'dirichlet','Edge',([1 2 3 4]),'h',1,'r',0);

%% Generate Mesh
% Create and view a finite element mesh for the problem.
generateMesh(model,'Hmax',0.2);
%
figure
pdemesh(model);
ylim([-1.1 1.1]);
axis equal
xlabel x
ylabel y

%% Create Initial Conditions
% The initial conditions:
%
% * $u(x,0) = \arctan\left(\cos\left(\frac{\pi x}{2}\right)\right)$.
% * $\left.\frac{\partial u}{\partial t}\right|_{t = 0} = 3\sin(\pi x)
% \exp\left(\sin\left(\frac{\pi y}{2}\right)\right)$.
%
% This choice avoids putting energy into the higher vibration modes
% and permits a reasonable time step size.

%u0 = @(location) 2*cos(0.5*pi*location.x).*cos(0.5*pi*location.y);
u0 = @(location) 1+cos(0.5*pi*location.x).*cos(0.5*pi*location.y);

setInitialConditions(model,u0);

%% Define Solution Times
% Find the solution at 31 equally-spaced points in time from 0 to 5.
n = 5;
tlist = linspace(0,0.15,n);

%% Calculate the Solution 
% Set the |SolverOptions.ReportStatistics| of |model| to |'on'|.
model.SolverOptions.ReportStatistics ='on';
result = solvepde(model,tlist);
u = result.NodalSolution;

%% Interpolation
newtlist = linspace(0,0.15,30*n);
unew = interp1(tlist,u',newtlist);
unew = unew';
%% Animate the Solution

%%
xline = linspace(-1,1,100);
yline = linspace(-1,1,100);

[xms, yms] = meshgrid(xline,yline);

height = 1e3;
hardness   = 100;

zms = exp((-xms.^2 - yms.^2)./0.15^2);

%%
figure('unit','norm','pos',[0 0 1 1])
umax = max(max(u));
umin = min(min(u));

clf
isol = pdeplot(model,'XYData',unew(:,1),'ZData',unew(:,1),'ZStyle','continuous',...
              'Mesh','off','XYGrid','on','ColorBar','off','FaceAlpha',0.8);
hold on
lightangle(10,10)
isurf = surf(xms,yms,zms,xms*0,'LineStyle','none','FaceLighting','gouraud');
axis('off')
title('Obstacle Problem')
colormap jet
zlim([-2 2.0])

az = 1;
el = 1;
view(isol.Parent,az,el)
pause(2)

for i = 1:(30*n)
    delete(isol)
    hold on
    isol = pdeplot(model,'XYData',unew(:,i),'ZData',unew(:,i),'ZStyle','continuous',...
                  'Mesh','off','XYGrid','on','ColorBar','off');
    isol.FaceLighting = 'gouraud';
              colormap jet
    title('Obstacle Problem')

    %axis([-1 1 -1 1 umin-0.1 umax]); 
    %caxis([umin umax]);
    
    az = az + 0.1;
    el = el + 0.1;
    view(isol.Parent,az,el)
        pause(0.0001)

end

%%
% To play the animation, use the |movie(M)| command.
