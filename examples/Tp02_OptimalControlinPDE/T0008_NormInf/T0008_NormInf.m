
L  = 1;
N  = 50;
xline = linspace(-1,1,N);

s  = 0.8;
A = FDLaplacian(xline);
B = BInterior(xline,-0.3,0.5);

dynamics = pde('A',A,'B',B);
dynamics.mesh = xline;
dynamics.FinalTime = 0.2;
dynamics.Nt = 100;
dynamics.InitialCondition = sin(pi*xline');



iOC = OptimalLsNorm(dynamics);

dx = xline(2) - xline(1);
iOC.kappa = 1/dx^4;
iOC.Target = sin(pi*xline');


iOC.s = 2;
iOC.sp = 2;
%iOC.Constraints.MinControl = 0;

U0 = zeros(length(dynamics.tspan),dynamics.Udim) + 0.01;
GradientMethod(iOC,U0,'display','all')
DynamicsDyCon = copy(iOC.Dynamics);
DynamicsDyCon.label = 'DyCon';
options   = optimoptions(@fminunc,'display','iter','SpecifyObjectiveGradient',true);
fminunc(@(U)Control2Functional(iOC,U),U0,options);

DynamicsFmincon = copy(iOC.Dynamics);
DynamicsFmincon.label = 'FminCon';


solve(dynamics);
dynamics.label = 'Free';
animation([dynamics,DynamicsDyCon,DynamicsFmincon],'xx',0.01,'Target',iOC.Target,'YLim',[-1 1])