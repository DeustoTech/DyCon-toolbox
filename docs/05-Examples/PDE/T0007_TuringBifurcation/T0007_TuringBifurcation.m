clear 
%% Define Geometry 
[tnodes,telements] = CreateGeometry();
%
model = createpde();

(model,tnodes,telements);
%% Define Equation
applyBoundaryCondition(model,'neumann','Edge',1:model.Geometry.NumEdges,'g',0);
%
specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);
%% Generate Mesh 
hmax = 0.45;
generateMesh(model,'Hmax',hmax,'GeometricOrder','linear','Hgrad',2);
%% Get a Finite elements Matrices
FEM = assembleFEMatrices(model,'stiff-spring');
Ns = length(FEM.Fs);
%
import casadi.*
%
Vs = SX.sym('v',Ns,1);
Us = SX.sym('u',Ns,1);
Ss = SX.sym('s',Ns,1);
ts = SX.sym('t');
Ws = [Vs;Us];

%%
lambda = 1.15;
kappa  = 0.0;
sigma  = 1.1; %%
%%
Us = Ws(1:Ns);
Vs = Ws(Ns+1:end);
%
du = 6.25*1e-6;       dv = 100*du;
mu = 0.001; 

Au = -du*FEM.Ks; Av = -dv*FEM.Ks;
%
A = [  Au        eye(Ns,Ns)  ;
     eye(Ns,Ns)     Av      ];
%%
Bu = sparse(Ns,Ns);

B = [    Bu     ;
     eye(Ns,Ns) ];
%
%%
NLT = Function('NLT',{ts,Ws,Ss},{ [  FEM.Fs + Us.*(Us.*Vs - mu)         ; ...
                                  FEM.Fs - Vs.*Us.^2       ]});
%%
Nodes    = model.Mesh.Nodes;
Elements = model.Mesh.Elements;
%
Nt =  20;
tspan = linspace(0,10,Nt);
%
idyn = semilinearpde2d(Ws,Ss,A,B,NLT,tspan,Nodes,Elements);

SetIntegrator(idyn,'OperatorSplitting')
%% Initial Condition
xms = Nodes(1,:)' ;yms = Nodes(2,:)' ;
rng(100)

rms = sqrt(xms.^2+yms.^2);
thms = atan2(yms,xms);
 
U0  = exp(-rms.^2/0.25^2);
V0  = 1;
%
idyn.InitialCondition = [U0(:); V0(:)];
%%
Wt = zeros(2*Ns,10*Nt);
for IT = 1:10
   wtsol =  solve(idyn,S0);
    
end
S0 = ZerosControl(idyn);
%%
U1 = full(Wt(1:Ns,1));
V1 = full(Wt(Ns+1:end,1));
%
figure(1)
clf
%
subplot(1,2,1)
ipatch = patch('Vertices',Nodes','Faces',Elements','FaceVertexCData',U1,'FaceColor','interp');
title('U')
colorbar
caxis([-1 1])
subplot(1,2,2)
jpatch = patch('Vertices',Nodes','Faces',Elements','FaceVertexCData',V1,'FaceColor','interp');
title('V')
colorbar
caxis([-1 1])
%
for it = 1:Nt
    ipatch.FaceVertexCData = full(Wt(1:Ns,it));
    jpatch.FaceVertexCData = full(Wt(Ns+1:end,it));
    pause(0.1)
end

%%


