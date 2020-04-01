clear

params.m1 = 1;
params.m2 = 1;

T = 10;
Nt = 500;
tspan = linspace(0,T,Nt);
s0 = [0 0 0.1 0 0 0]';

st = zeros(Nt,6);
st(1,:) = s0;


eps0 = 0.999;


nangle = @(angle) min(mod(angle,2*pi), 2*pi-mod(angle,2*pi));

Rfcn = @(s) - nangle(s(2))^2 - nangle(s(3))^2;

%Rfcn = @(s) - mods(2:3)'*s(2:3)
data = zeros(6,(Nt-1));
r = zeros(1,(Nt-1));
Qdata = zeros(1,(Nt-1));

ut = zeros(1,(Nt-1));
umax = +50;
umin = -50;


eps = eps0;

cs = rand(1,6)-0.5;
Q = @(s,a) (cs*s)*a;
alpha = 0.1;
gamma = 0.5;
%%

theta1 = linspace(0,2*pi,4);
theta2 = linspace(0,2*pi,4);
%v      = linspace(-10,10,4);
omega1 = linspace(-5,5,4);
omega2 = linspace(-5,5,4);

uline  = linspace(umin,umax,10);

Qtable = 0.1*rand(length(theta1),length(theta2),length(omega1),length(omega2),length(uline))-0.5;

%%
epochs = 3000;
clf
ax = axes; 
ylim([-5 10])
xlim([1 Nt])

for iepo = 1:epochs
   eps = eps0/iepo^(1/4);

   for it = 1:Nt-1
       
           [~ ,ind_theta1] = min(abs(theta1-mod(st(it,2),2*pi)));
           [~ ,ind_theta2] = min(abs(theta2-mod(st(it,3),2*pi)));
           %[~ ,ind_v     ] = min(abs(v-st(it,4)));
           [~ ,ind_omega1] = min(abs(omega1-st(it,5)));
           [~ ,ind_omega2] = min(abs(omega2-st(it,6))); 
           
           old_index = {ind_theta1,ind_theta2,ind_omega1, ind_omega2};
        
           if eps > rand 
             u= umax*2*(rand-0.5);
             [~,ind_action] = min(abs(u-uline));       
           else          
                Qa = [Qtable(old_index{:},:)];
                Qa = reshape(Qa,1,length(uline));
                [Qa_max,ind_action] = max(Qa);
                u = uline(ind_action);      
           end
       %

      dt = tspan(it+1) - tspan(it);
      %%
      st(it+1,:) = st(it,:) + dt*cartpole_dynamics(tspan(it),st(it,:)',u,params)';
      
      %%
      r(it) = Rfcn(st(it+1,:)');
        
      if isnan(r(it)) 
            break
      end
      ut(it) = u;
        
      %% learning
      % max 
       [~ ,ind_theta1_new] = min(abs(theta1-mod(st(it+1,2),2*pi)));
       [~ ,ind_theta2_new] = min(abs(theta2-mod(st(it+1,3),2*pi)));
       %[~ ,ind_v_new     ] = min(abs(v-st(it+1,4)));
       [~ ,ind_omega1_new] = min(abs(omega1-st(it+1,5)));
       [~ ,ind_omega2_new] = min(abs(omega2-st(it+1,6)));
       new_index = {ind_theta1_new,ind_theta2_new,ind_omega1_new, ind_omega2_new};

       %
       Qa_new = [Qtable(new_index{:},:)];
       Qa_new = reshape(Qa_new,1,length(uline));
       
       [Qa_max_new,~] = max(Qa_new);
        %
            
        
        Qtable(old_index{:},ind_action) = Qtable(old_index{:},ind_action)*(1-alpha)  + alpha*(r(it) + gamma*Qa_max_new -  Qtable(old_index{:},ind_action) );
       
      %%
      if r(it) < -5
         break 
      end
      %%
   end
   
   if mod(iepo,50) == 0
       hold on; 
       if exist('l1')
          l1.Color = [0.9 0.9 0.9];
       end
       l1 = line(1:it,mod(r(1:it),2*pi),'Parent',ax);
       pause(0.1)
   end
end


%%
fig = figure(1); cartpole_animation_several(fig,st,tspan,5.5)