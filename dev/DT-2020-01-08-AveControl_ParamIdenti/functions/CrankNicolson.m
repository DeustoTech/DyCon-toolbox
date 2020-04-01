function [tspan,X] = CrankNicolson(f,tspan,x0)
%RK4 Summary of this function goes here


Nt = length(tspan);
N = length(x0);

X = zeros(Nt,N);

X(1,:) = x0;
 options = optimoptions('fsolve','Display','off');
 options.FunctionTolerance = 1e-12;
for k=2:Nt % loop over control intervals

   dt = tspan(k) - tspan(k-1);
   %
   [xsol,~] =fsolve( ...
            @(xnext) xnext - X(k-1,:)' - 0.5*dt*f(tspan(k-1),X(k-1,:)') - 0.5*dt*f(tspan(k),xnext), ...
            X(k-1,:)',options);  
%
   X(k,:) = xsol';
end


end

