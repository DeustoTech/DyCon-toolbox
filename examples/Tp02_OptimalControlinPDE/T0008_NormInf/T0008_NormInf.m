
L  = 1;
N  = 50;
xline = linspace(-1,1,N);

s  = 0.8;
A = FDLaplacian(xline);
B = BInterior(xline,-0.3,0.5);

dynamics = pde('A',A,'B',B);
dynamics.mesh = xline;
dynamics.FinalTime = 0.2;
dynamics.dt = 0.01;
dynamics.InitialCondition = sin(pi*xline');



iOC = OptimalLsNorm(dynamics);

dx = xline(2) - xline(1);
iOC.kappa = 1/dx^4;
iOC.Target = sin(pi*xline');


iOC.s = 2;
iOC.sp = 2;
iOC.Constraints.MinControl = 0;

U0 = zeros(length(dynamics.tspan),dynamics.Udim) + 0.01;
GradientMethod(iOC,U0,'display','all','DescentParameters',{'FixedLengthStep',false,'LengthStep',1e-5},'Graphs',false)


solve(dynamics)
animation([iOC.Dynamics,dynamics],'xx',0.1,'Target',iOC.Target,'YLim',[-1 1])