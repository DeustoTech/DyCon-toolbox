%% Heat Conduction in Multidomain Geometry with Nonuniform Heat Flux
% This example shows how to perform a 3-D transient heat conduction
% analysis of a hollow sphere made of three different layers of material.
%
% The sphere is subject to a nonuniform external heat flux.
%

% Copyright 2015-2018 The MathWorks, Inc.

%% Problem Description
% The physical properties and geometry of this problem are described in
% Singh, Jain, and Rizwan-uddin <#20 [1]>, which also has an analytical
% solution for this problem. The inner face of the sphere has a temperature
% of zero at all times. The outer hemisphere with positive $y$ value has a
% nonuniform heat flux defined by
%
% $$ q_{\rm{outer}} = \theta^2(\pi - \theta)^2 \phi^2(\pi - \phi)^2 $$ 
% 
% $$ 0 \le \theta \le \pi, 0 \le \phi \le \pi .$$ 
%
% $\theta$ and $\phi$ are azimuthal and elevation angles of points in the
% sphere. Initially, the temperature at all points in the sphere is zero.
 
%% Create Thermal Model
% Create a thermal model for transient thermal analysis.
thermalmodel = createpde('thermal','transient');
 
%% Define Geometry
% Create a multilayered sphere using the |multisphere| function.
% Assign the resulting geometry to the thermal model. The sphere has three
% layers of material with a hollow inner core.
gm = multisphere([1 4],'Void',[true,false]);
thermalmodel.Geometry = gm;
 
%% Plot Geometry with Face and Cell Labels
%
% Plot the geometry and show the cell labels and face labels. Use a
% |FaceAlpha| of 0.25 so that labels of the interior layers are visible.
figure('Position',[10,10,800,400]);
subplot(1,2,1)
pdegplot(thermalmodel,'FaceAlpha',0.25,'CellLabel','on')
title('Geometry with Cell Labels')
subplot(1,2,2)
pdegplot(thermalmodel,'FaceAlpha',0.25,'FaceLabel','on')
title('Geometry with Face Labels')
 
%% Generate Mesh
% Generate a mesh for the geometry. Choose a mesh size that is coarse
% enough to speed the solution, but fine enough to represent the geometry
% reasonably accurately.
generateMesh(thermalmodel,'Hmax',1);
 
%% Specify Thermal Properties
% Specify thermal conductivity, mass density, and specific heat for each
% layer of the sphere. The material properties are dimensionless values,
% not given by realistic material properties.
thermalProperties(thermalmodel,'Cell',1,'ThermalConductivity',1, ...
                                        'MassDensity',1, ...
                                        'SpecificHeat',1);
% thermalProperties(thermalmodel,'Cell',2,'ThermalConductivity',2, ...
%                                         'MassDensity',1, ...
%                                         'SpecificHeat',0.5);
% thermalProperties(thermalmodel,'Cell',3,'ThermalConductivity',4, ...
%                                         'MassDensity',1, ...
%                                         'SpecificHeat',4/9);
 
%% Boundary Conditions
% The innermost face has a temperature of zero at all times.
thermalBC(thermalmodel,'Face',1,'Temperature',0);

%%
% Include this boundary condition in the model.
thermalBC(thermalmodel,'Face',1,'HeatFlux',0,'Vectorized','on');
 
%% Initial Conditions
% Define the initial temperature to be zero at all points.
thermalIC(thermalmodel,@initcon);
 
%% Solve Problem
% Define a time-step vector and solve the transient thermal problem.
tlist = linspace(0,0.5,7);
R = solve(thermalmodel,tlist);
 
%% Animate Temperature Over Time
% To plot contours at several times, with the contour levels being the same
% for all plots, determine the range of temperatures in the solution. The
% minimum temperature is zero because it is the boundary condition on the
% inner face of the sphere.
Tmin = 0;
%%
% Find the maximum temperature from the final time-step solution.
Tmax = max(R.Temperature(:,1)*0.05 + 0.95*R.Temperature(:,end));
Tmax = 0.015;
% Plot contours in the range |Tmin| to |Tmax| at the times in |tlist|.
h = figure('Color','none');
iter = 0;

cellstringdata = {'Final State','Initial Condition Recovered'};

ax1 = axes('Parent',h,'unit','norm','pos',[0 0 0.5 1],'Color','none')
ax2 = axes('Parent',h,'unit','norm','pos',[0.5 0 0.5 1],'Color','none')

axs ={ax1,ax2}
for i = [numel(tlist) 1]
    iter = iter + 1;
    set(h,'CurrentAxes',axs{iter})
    pt = pdeplot3D(thermalmodel,'ColorMapData',R.Temperature(:,i),'mesh','off');
    pt(2).Parent.Parent.Color = 'none'
    axs{iter}.Color = 'none';
    shading interp
    colormap('jet')
    colorbar('off')
    
    caxis([Tmin,Tmax])
    view(45,50)
    %title(cellstringdata{iter});
    M(i) = getframe;
    lightangle(-10,10)
    lightangle(10,160)

    lighting gouraud
end

h.Color = 'none'
%%
saveas(h,'Barchart2.png')

function result = initcon(location)
    k = 20;
    x = location.x;
    y = location.y;
    z = location.z;

    ampl = 0.5;
    deltax = (2*k*exp(-2*k*(x-0.5)))./(exp(-2*k*(x-0.5)) + 1).^2;
    deltay = (2*k*exp(-2*k*(y-0.5)))./(exp(-2*k*(y-0.5)) + 1).^2;

    result1 = ampl*deltax.*deltay;

    x0 = 1;
    deltax = (2*k*exp(-2*k*(x-x0)))./(exp(-2*k*(x-x0)) + 1).^2;
    deltay = (2*k*exp(-2*k*y))./(exp(-2*k*y) + 1).^2;
    
    result2 = 0*ampl*deltax.*deltay;
    
    z0 = 1;
    deltaz = (2*k*exp(-2*k*(z-z0)))./(exp(-2*k*(z-z0)) + 1).^2;
    deltax = (2*k*exp(-2*k*x))./(exp(-2*k*x) + 1).^2;
    
    result3 = ampl*deltax.*deltaz;
    result = result1 + result2 + result3;
end
