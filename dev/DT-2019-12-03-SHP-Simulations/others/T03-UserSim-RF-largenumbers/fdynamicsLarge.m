function xnext = fdynamics(x,u,b)
%FDYNAMICS 
%
Ne = length(x);
% Feedback simulation
xnext = zeros(Ne,1);
for i = 1:Ne
    population   =  [  1     ,    0     ];
    distribution =  [b(u(i)+1) , 1-b(u(i)+1)];
    %    
    xnext(i) = randsample(population,1,true,distribution);
end

end

