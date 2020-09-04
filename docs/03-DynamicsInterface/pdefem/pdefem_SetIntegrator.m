%%
% Create a points an elements
t = linspace(pi/30,2*pi,30);
pgon = polyshape({[0.5*sin(t)]},{[0.5*cos(t)]});
          
tr = triangulation(pgon);
%
tnodes    = tr.Points';
telements = tr.ConnectivityList';
%%
% With these we can create a FEM matrices with help to MATLAB PDE Toolbox
model = createpde();
geometryFromMesh(model,tnodes,telements);
%%
% Define Equation
applyBoundaryCondition(model,'neumann','Edge',1:model.Geometry.NumEdges,'g',0);
specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);
%%
% and generate mesh 
hmax = 0.05;
generateMesh(model,'Hmax',hmax,'GeometricOrder','linear','Hgrad',2);
%%
% Get a Finite elements Matrices
FEM = assembleFEMatrices(model,'stiff-spring');
Ns = length(FEM.Fs);
%%
import casadi.*
%
Us = SX.sym('w',Ns,1);
Vs = SX.sym('v',Ns,1);
ts = SX.sym('t');
%% 
% Define the dynamic
Fs = casadi.Function('f',{ts,Us,Vs},{ FEM.Fs + FEM.Ks*Us + Vs });
%
tspan = linspace(0,2,50);
%
Nodes    = model.Mesh.Nodes;
Elements = model.Mesh.Elements;
%
ipdefem = pdefem(Fs,Us,Vs,tspan,Nodes,Elements);
%% 
% Initial Condition
xms = ipdefem.Nodes(1,:)' ;yms = ipdefem.Nodes(2,:)' ;
% radial coordinates
rms  = sqrt(xms.^2+yms.^2);
thms = atan2(yms,xms);

U0 =  exp((-xms.^2-yms.^2)/0.25^2);
%%
ipdefem.InitialCondition = U0(:);
%
Vt = ZerosControl(ipdefem);
%%
% Before solve ode object must be set Integrator
SetIntegrator(ipdefem,'RK4')
ut_RK4 = solve(ipdefem,Vt)
%% 
SetIntegrator(ipdefem,'RK8')
ut_RK8 = solve(iode,Vt)
