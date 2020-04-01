clear 
Nt = 10;
Nq = 3;

alpha = 0.1;

b = rand(Nq,1);
while norm(b) < 0.2
    b = rand(Nq,1);
end
%%
A = -eye(Nq);
B = +eye(Nq);
dt = 0.2;
f = @(x,u) min(floor(b.*u),4);

%
t = zeros(Nq,Nt);
% Control
ut = randi(10,Nq,Nt);
%
 ut = [5.0*ones(1   ,Nt);
       6.0*ones(1,Nt);
       7.0*ones(Nq-2,Nt)];
%
xt = zeros(Nq,Nt);

x0 = 0*randi(1,Nq,1);
xt(:,1) = x0;
%
for it = 2:Nt
    xt(:,it) = f(xt(:,it-1),ut(:,it-1));
end 

%%
clf
subplot(2,1,1)
plot(xt(:,1:end)','--o')
legend(strcat(repmat('rt',Nq,1),num2str((1:Nq)')))
title('State')
subplot(2,1,2)
plot(ut','--o')
legend(strcat(repmat('ut',Nq,1),num2str((1:Nq)')))
title('Control')


function xnext = f(x,u,b)
    
end