function generate_dynamics(h)
%GENERATE_DYNAMICS Summary of this function goes here
%   Detailed explanation goes here
Nx = 35; Ny = 35;

[~,~,A] = laplacian([Nx,Ny],{'NN' 'NN'});

xmin = -1; xmax = 1;
ymin = -1; ymax = 1;

xline = linspace(xmin,xmax,Nx);
yline = linspace(ymin,ymax,Ny);

v1 = 5;v2 = 2;

dx = xline(2) - xline(1);
dy = yline(2) - yline(1);

CoefDiff = 0.1;
%A = -(CoefDiff/(dx*dy))*A;
A = -diffusion_matrices(xline,yline,CoefDiff);
V = -advection_matrices(xline,yline,v1,v2);

C = A + V;
%C = A;


idyn = pde('A',C);


idyn.mesh = {xline,yline};

Nt = 100;
idyn.FinalTime  = 0.3;
idyn.dt         = idyn.FinalTime/Nt;


h.dynamics = idyn;

h.grid.dx = dx;
h.grid.dy = dy;

h.grid.xline = xline;
h.grid.yline = yline;
h.grid.Nx = Nx;
h.grid.Ny = Ny;
h.grid.xmax = xmax;
h.grid.ymax = ymax;
h.grid.xmin = xmin;
h.grid.ymin = ymin;
end

