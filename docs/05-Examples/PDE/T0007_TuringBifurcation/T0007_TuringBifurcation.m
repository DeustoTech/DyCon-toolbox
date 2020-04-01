clear 
%% Define Geometry 
[tnodes,telements] = CreateGeometry();
%
model = createpde();
geometryFromMesh(model,tnodes,telements);
%% Define Equation
applyBoundaryCondition(model,'neumann','Edge',1:model.Geometry.NumEdges,'g',0);
%
specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);
%% Generate Mesh 
hmax = 0.0275;
hmax = 0.0275;

generateMesh(model,'Hmax',hmax,'GeometricOrder','linear','Hgrad',2);
%% Get a Finite elements Matrices
FEM = assembleFEMatrices(model,'stiff-spring');
Ns = length(FEM.Fs);
%
import casadi.*
%
Ws = SX.sym('w',2*Ns,1);
Ss = SX.sym('s',Ns,1);
ts = SX.sym('t');
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
B = sparse(Ns,Ns);

%%
f= @(u) lambda*u - u.^3 - kappa;

% Fs = casadi.Function('f',{ts,Ws,Ss},{ [ FEM.Fs + Au*Us + f(Us) - sigma*Vs             ; ...
%                                         FEM.Fs + Av*Vs +  Us   - Vs       + B*Ss       ]});
%

Fs = casadi.Function('f',{ts,Ws,Ss},{ [ FEM.Fs + Au*Us + Us.*(Us.*Vs - mu)             ; ...
                                        FEM.Fs + Av*Vs - Vs.*Us.^2 + B*Ss       ]});

Nodes    = model.Mesh.Nodes;
Elements = model.Mesh.Elements;
%
Nt =  100;
tspan = linspace(0,170,Nt);
%
idyn = pdefem(Fs,Ws,Ss,tspan,Nodes,Elements);
SetIntegrator(idyn,'RK4')
%% Initial Condition
xms = Nodes(1,:)' ;yms = Nodes(2,:)' ;
rng(100)

rms = sqrt(xms.^2+yms.^2);
thms = atan2(yms,xms);

expf = @(x,y) exp((-(xms-x).^2-(yms-y).^2)/0.04^2);
U0  =  (cos(6*thms).^10).*expf(0.0,0.0); 
U0  = U0 + 0.00075*rand(size(U0));

V0  = rms.^2 + 0.75 ;
%%
idyn.InitialCondition = [U0(:); V0(:)];
%
%
rep = 400;
%
St = ZerosControl(idyn);

Wt_tot =zeros(2*Ns,rep);
for IT = 1:rep
    Wt_tot(:,IT) = full(idyn.InitialCondition); 

    Wt = solve(idyn,St);
    %
    idyn.InitialCondition = Wt(:,end);
    if mod(IT,100) == 0
        fprintf( "  iter = "+ num2str(IT,'%d') +"\n")
    end
end
%%
St_tot_gr = full(Wt_tot(1:Ns,:))';
St_tot = cumsum(St_tot_gr)';
%%
fig = figure(2);
fig.Units = 'norm';
fig.Position = [0.1 0.1 0.5 0.3];
clf
plotTB(St_tot,Wt_tot,Ns,model,hmax)

%%