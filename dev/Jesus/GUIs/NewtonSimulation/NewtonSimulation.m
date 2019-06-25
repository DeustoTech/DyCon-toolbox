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
syms t
Control = u;
% create de ode structure with the DyCon ToolBox syntax;
F = matlabFunction(F,'Vars',{t,StateVector,Control,sym.empty});
dynamics = ode(F,StateVector,Control);
% choose our options 
dynamics.InitialCondition = [10  -1e-6  0.0  0.0]'; % [x0 y0 vx0 vy0]  % stable 

dynamics.FinalTime        = 80;          % Tend = 50 
dynamics.Nt               = 500;         % Number of Time points   
%% Solve Dynamics
[~,StateSolution] = solve(dynamics);