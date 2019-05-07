function generate_dynamics(h)
%GENERATE_DYNAMICS Summary of this function goes here
%   Detailed explanation goes here

Nx = h.N; Ny = h.N;

xmin = -1; xmax = 1;
ymin = -1; ymax = 1;


v1 = 5;v2 = 3;


xline = linspace(xmin,xmax,Nx);
yline = linspace(ymin,ymax,Ny);


dx = xline(2) - xline(1);
dy = yline(2) - yline(1);

CoefDiff = 0.5;
%A = -(CoefDiff/(dx*dy))*A;
A = -diffusion_matrices(xline,yline,CoefDiff);
V = -advection_matrices(xline,yline,v1,v2);
%V = advection_matrices_upwind(xline,yline,v1,v2);

h.matrix.A = A;
h.matrix.V = V;


C = A + V;
%C = V;


idyn = pde('A',C);


idyn.mesh = {xline,yline};

Nt = 5;
%Nt = 50;
idyn.FinalTime  = 0.1;
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

