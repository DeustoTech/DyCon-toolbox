
# tp1dcb0d7a_2812_4059_b0c9_63df7a20d6c0


Create a points an elements



```matlab
t = linspace(pi/30,2*pi,30);
pgon = polyshape({[0.5*sin(t)]},{[0.5*cos(t)]});

tr = triangulation(pgon);
%
tnodes    = tr.Points';
telements = tr.ConnectivityList';
```


With these we can create a FEM matrices with help to MATLAB PDE Toolbox



```matlab
model = createpde();
geometryFromMesh(model,tnodes,telements);
```


Define Equation



```matlab
applyBoundaryCondition(model,'neumann','Edge',1:model.Geometry.NumEdges,'g',0);
specifyCoefficients(model,'m',0,'d',0,'c',1,'a',0,'f',0);
```


and generate mesh



```matlab
hmax = 0.05;
generateMesh(model,'Hmax',hmax,'GeometricOrder','linear','Hgrad',2);
```


Get a Finite elements Matrices



```matlab
FEM = assembleFEMatrices(model,'stiff-spring');
Ns = length(FEM.Fs);
```



```matlab
import casadi.*
%
Us = SX.sym('w',Ns,1);
Vs = SX.sym('v',Ns,1);
ts = SX.sym('t');
```


Define the dynamic



```matlab
Fs = casadi.Function('f',{ts,Us,Vs},{ FEM.Fs + FEM.Ks*Us + Vs });
%
tspan = linspace(0,2,50);
%
idyn = pdefem(Fs,Us,Vs,tspan,tnodes,tnodes);
SetIntegrator(idyn,'RK4')
```


Initial Condition



```matlab
xms = Nodes(1,:)' ;yms = Nodes(2,:)' ;
% radial coordinates
rms  = sqrt(xms.^2+yms.^2);
thms = atan2(yms,xms);

U0 =  exp((-xms.^2-yms.^2)/0.25^2);
```



```matlab
idyn.InitialCondition = U0(:);
%
Vt = ZerosControl(idyn);
Wt = solve(idyn,Vt);
%
Wt
```




```

Wt = 


[[0.0183156, 0.0179932, 0.0176703, ..., -0.0567949, -0.0654909, -0.0753068], 
 [0.0182246, 0.0178072, 0.0173858, ..., -0.0430701, -0.0483894, -0.0542836], 
 [0.0185783, 0.018069, 0.0175525, ..., -0.0577603, -0.0643154, -0.0715892], 
 ...,
 [0.141174, 0.140772, 0.140377, ..., 0.447323, 0.49929, 0.559693], 
 [0.122455, 0.122056, 0.12166, ..., 0.203015, 0.218401, 0.236377], 
 [0.102459, 0.102, 0.101541, ..., 0.139265, 0.149296, 0.161212]]

```



