function [tspan,X] = rk8(f,tspan,x0)
%RK4 Summary of this function goes here


Nt = length(tspan);
N = length(x0);

X = zeros(Nt,N);

X(1,:) = x0;
for k=2:Nt % loop over control intervals
   % Euler forward method
   dt = tspan(k) - tspan(k-1);
   %
   k1 = f(tspan(k-1)         ,  X(k-1,:)              );
   k2 = f(tspan(k-1)+0.5*dt  ,  X(k-1,:)+0.5*k1'*dt    );
   k3 = f(tspan(k-1)+0.5*dt  ,  X(k-1,:)+0.5*k2'*dt    );
   k4 = f(tspan(k-1)+1.0*dt  ,  X(k-1,:)+1.0*k3'*dt    );
   %
   X(k,:) = X(k-1,:) + (1/6)*dt*(k1 + 2*k2 + 2*k3 + k4)'; 
end


end

