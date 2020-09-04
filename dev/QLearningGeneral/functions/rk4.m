function [tspan,X] = rk4(f,tspan,x0)
%RK4 Summary of this function goes here


Nt = length(tspan);
N = length(x0);

X = zeros(Nt,N);

X(1,:) = x0;
for k=2:Nt % loop over control intervals
   % Euler forward method
   dt = tspan(k) - tspan(k-1);

   X(k,:) = rk4_step(f,tspan(k-1),dt,X(k-1,:)')';
   
end



end

