clear all


%% Dynamics Definition
syms x y vx vy

% Define the potential
V = +5e-2*(x.^2 - y.^2);  % Hiperbolic
%V = +5e-2*(x.^2 + y.^2);    % Parabolic

% Create the function handle version of the potential
Vfh = matlabFunction(V,'Vars',{x,y});

% Create the State Vector 
StateVector = [x y vx vy].';
% Create the dynamics: \dot{StateVector} = F(t,StateVector,Control)
F = [       vx   ; ...
            vy   ; ...
      -diff(V,x) - 0.00*vx; ...
      -diff(V,y) - 0.00*vy];
% We create the control - We need this because DyCon Toolbox need a some
% control
syms u
Control = u;
% create de ode structure with the DyCon ToolBox syntax;
dynamics = ode(F,StateVector,Control);
% choose our options 
dynamics.InitialCondition = [10  0.01  0.0  0.0]'; % [x0 y0 vx0 vy0]  % stable 
%dynamics.InitialCondition = [10  0.001 0.0 0.0]'; % [x0 y0 vx0 vy0] % 

dynamics.FinalTime        = 80;          % Tend = 50 
dynamics.Nt               = 150;         % Number of Time points   
%% Solve Dynamics
[~,StateSolution] = solve(dynamics);
%% Define mesh 
XLim = [-20 20];
YLim = [-20 20];
%
xline = linspace(XLim(1),XLim(2),50);
yline = linspace(YLim(1),YLim(2),50);
%
[xms ,yms] = meshgrid(xline,yline);
zms = Vfh(xms,yms);
%% Create Graphs Objects
clf
% Create the mesh of shere
[X,Y,Z] = sphere;
radius = 2;
X = X*radius; Y = Y*radius; Z = Z*radius;
% create the sphere object
isurf = surf(X,Y,Z);
% set color of sphere
isurf.CData = isurf.CData*0 + 1;
shading interp
%
hold on 


% Create the potential with some FaceAlpha (Transparent)
surf(xms,yms,zms,'FaceAlpha',0.3);

%% Create animation 
AzAngle = -210; 
ElAngle   = 37;

% fixed Limits of Graphs
isurf.Parent.XLim = XLim;
isurf.Parent.YLim = YLim;
isurf.Parent.ZLim = isurf.Parent.ZLim;
%% setting axes 
daspect([1 1 1])
lightangle(165,73)
axis(isurf.Parent,'off')

% gif('animation.gif','DelayTime',1/11) % <= to create gif
for it = 1:dynamics.Nt
    % change the sphere position
    isurf.XData = X + StateSolution(it,1);
    isurf.YData = Y + StateSolution(it,2);
    isurf.ZData = Z + Vfh(StateSolution(it,1),StateSolution(it,2)) + radius;
    % change the Azimutal Angle in 0.1 degree
    AzAngle = AzAngle + 0.0;
    view(isurf.Parent,AzAngle,ElAngle)
    % pause for see the update graphs 
    pause(0.01)
    % get frame of figure
    % gif('frame',isurf.Parent) % <== to create gif
    % stop animation when the potential is very high
    if abs(Vfh(StateSolution(it,1),StateSolution(it,2))) > 200
        break
    end
end
