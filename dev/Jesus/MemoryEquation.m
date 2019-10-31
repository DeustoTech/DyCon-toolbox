%%
Nt = 100;
Nx = 100;
xline = linspace(-1,1,Nx);
Lap = FDLaplacian(xline);
In = eye(Nx);
Zr = zeros(Nx);
A = [Lap,In;In Zr];
%%
Y0 = cos(0.5*pi*xline');
W0 = [Y0;zeros(Nx,1)];
tspan = linspace(0,4,Nt);
[tspan,Wt] = ode45(@(t,W) A*W,tspan,W0);

figure('unit','norm','pos',[0 0 1 1])
surf(Wt)

