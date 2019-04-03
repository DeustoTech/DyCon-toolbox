
s  = 0.8
L  = 1;
N  = 10;
xline = linspace(-1,1,N);

A = -FEFractionalLaplacian(s,L,N);
B = BInterior(xline,-0.3,0.5);

dynamics = pde('A',A,'B',B);
dynamics.mesh = xline;

OptimalLsNorm(dynamics)