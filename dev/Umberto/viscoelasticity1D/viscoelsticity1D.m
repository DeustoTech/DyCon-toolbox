N = 100;
Nt = 100;
ssline = linspace(0.01,0.99,14);
%ssline = [0.1 0.5 0.9]
xi = -1; xf = 1;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);
M = MassMatrix(xline);
a = -0.3; b = 0.8;
B = BInterior(xline,a,b,'Mass',true);

FinalTime = 5.5;
Y0 =cos(pi*xline');
Y0(xline > 0.2) = 0
Y0(xline < -0.2) = 0

s = 0.05;

coeff = 3;
A = -coeff*FEFractionalLaplacian(s,1,N);
dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'Nt',Nt);
dynamics.mesh = xline;
dynamics.MassMatrix = M;
dynamics.Nt = Nt;

%%
tspan = dynamics.tspan;

[xms, tms] = meshgrid(xline,tspan);

alpha = 0.1;
U = 50*exp(-xms.^2/alpha^2);


alphatime = 0.01*FinalTime;
Ut = 50*exp(-(xms-0.5).^2/alpha^2).*exp(-(tms-0.8*FinalTime).^2/alphatime^2);


U = U - Ut;
%%
[~,Ysol] = solve(dynamics,'Control',U);

%%

animation(dynamics,'YLim',[-0.25 1],'xx',0.6)

