function ut = thetasolver(u0,A,b,tspan,theta)

Nx = length(u0);
Nt = length(tspan);
ut = zeros(length(u0),Nt);

dt = tspan(2) - tspan(1);
C = (eye(Nx) - theta*dt*A);

ut(:,1) = u0;
for it = 2:Nt
    ut(:,it) = C\(ut(:,it-1) + (1-theta)*dt*A*ut(:,it-1) + dt*b);
end



