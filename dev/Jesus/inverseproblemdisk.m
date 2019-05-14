%% Helmholtz's Equation on Unit Disk with Square Hole
% This example shows how to solve a Helmholtz equation using the |solvepde|
% function.
%
% The Helmholtz equation, an elliptic equation that is the time-independent
% form of the wave equation, is
%
% $-\Delta u-k^2u = 0$.
%
% Solving this equation allows us to compute the waves reflected by a
% square object illuminated by incident waves that are coming from the
% left.

%       Copyright 1994-2015 The MathWorks, Inc.

%% Problem Definition
% The following variables define our problem:
%
% * |g|: A geometry specification function. For more information, see the
% code for |scatterg.m| and the documentation section
% <matlab:helpview(fullfile(docroot,'toolbox','pde','helptargets.map'),'pde_geometry_fcn');
% Create Geometry Using a Geometry Function>.
% * |k|, |c|, |a|, |f|: The coefficients and inhomogeneous term.
k = 60;
c = 1;
a = 0;
f = 0;

%% Create PDE Model
% Create a PDE Model with a single dependent variable.
numberOfPDE = 1;
model = createpde(numberOfPDE);

%%
% Convert the geometry and append it to the pde model.
%      rectangle code, 4 is the number of sides, followed by X and then Y
%      coordinates.
%      R1 = [3,4,-1,1,1,-1,-.4,-.4,.4,.4]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
R1 = [          3, ...                  % rectangle code
                4, ...                  % number of side 
      -1.0 ,+1.0 , 1.00 ,  -1.00  , ...   % x-coordinate 
      -1.0 ,-1.0 , 1.00 ,  +1.00 ]';      % y-coordinate 
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
C1 = [   +1.0   ,  ...    % circle code
         +0.2   ,  ...    % x - coordinate
         -0.5   ,  ...    % y - coordinate
          0.7]' ;         % radius
            
C1 = [C1;zeros(length(R1) - length(C1),1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
C2 = [   +1.0   ,  ...    % circle code
         -0.5   ,  ...    % x - coordinate
         +0.8   ,  ...    % y - coordinate
          0.1]' ;         % radius
            
C2 = [C2;zeros(length(R1) - length(C2),1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
E1 = [   +4.0   ,  ...    % circle code
         +0.7   ,  ...    % x - coordinate
         +0.5   ,  ...    % y - coordinate
          0.1   ,  ...    % x-radius 
          0.2    ]' ;     % y-radius
E1 = [E1;zeros(length(R1) - length(E1),1)];


gm = [R1,C1,C2,E1];
sf = 'R1-C1-C2-E1';

gm = C1;
sf = 'C1';

%
%ns = char('R1','C1','C2','E1');
ns = char('C1')
ns = ns';
g = decsg(gm,sf,ns);
%
geometryFromEdges(model,g);

%% Specify PDE Coefficients
specifyCoefficients(model,'m',0,'d',1,'c',10,'a',0,'f',@fcoeffunction);

%% Boundary Conditions
% Plot the geometry and display the edge labels for use in the boundary
% condition definition.
figure; 
pdegplot(model,'EdgeLabels','on'); 
axis equal
title 'Geometry With Edge Labels Displayed';

%%
% Apply the boundary conditions.
%bInner = applyBoundaryCondition(model,'dirichlet','Edge',(1:4));
bInner = applyBoundaryCondition(model,@bcd,'Edge',(1:4));

%% Create Mesh
generateMesh(model,'Hmax',0.1);
figure
pdemesh(model); 
axis equal

%% Solve for Complex Amplitude
% The real part of the vector |u| stores an approximation to a real-valued solution of the
% Helmholtz equation.

gauss = @(max,sigma,x,y) max*exp(-(x.^2 + y.^2).^2/sigma.^2 );

u0fun =  @(location) gauss(1   , 0.001  ,location.x -0.25     ,location.y + 0.5   )    + ...
                     gauss(10   , 0.001  ,location.x + 0.5    ,location.y         )    + ...
                     gauss(50   ,  0.001 ,location.x  + 0.5    ,location.y + 0.5   )   ;
setInitialConditions(model,u0fun)
%%

T = 0.01;
tspan = linspace(0,T,20);
result = solvepde(model,tspan);
u = result.NodalSolution;

%% Plot FEM Solution
figure
% pdeplot(model,'XYData',real(u),'ZData',real(u),'Mesh','off');
pdeplot(model,'XYData',abs(u),'Mesh','off');
colormap(jet)

%% Animate Solution to Wave Equation
% Using the solution to the Helmholtz equation, construct an animation showing
% the corresponding solution to the time-dependent wave equation.
figure
m = 10;
h = newplot; 
hf = h.Parent; 
axis tight
ax = gca;
ax.DataAspectRatio = [1 1 1];
axis off
maxu = max(abs(u));


Ntanimation = 50;
new_tspan = linspace(0,T,Ntanimation);
new_u     = interp1(tspan,u',new_tspan);
%%
ax = gca;
ax.DataAspectRatio = [1 1 1]; 
axis off
for j = 1:Ntanimation
    pdeplot(model,'XYData',new_u(j,:),'ColorBar','off','Mesh','off');
    colormap(jet)
    title("iter = " + j)
    caxis([0 0.1])
    daspect([ 1 1 1])
    %axis tight

    pause(0.05)
end
%%
function f = fcoeffunction(location,state)
% Now the particular functional form of f
vx = 10*cos(2*pi*location.x); vy = 10*sin(4*pi*location.y);
vx = 1;
vy = 0;
f = -vy.*state.ux - vx.*state.uy;

end
function bcd(a,b,c,d)
'Hola'
end
%%
% To play the movie 10 times, use the |movie(hf,M,10)| command.