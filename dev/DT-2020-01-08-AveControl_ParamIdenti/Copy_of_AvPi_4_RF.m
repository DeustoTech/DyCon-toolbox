clear all

params.m1 = 1;
params.m2 = 1;

T = 20;
Nt = 10000;
tspan = linspace(0,T,Nt);
s0 = [0 0 0.1 0 0 0]';

st = zeros(Nt,6);
st(1,:) = s0;


eps0 = 0.3;

%Rfcn = @(s) - norm(min(mod(-s(2:3)',2*pi),2*pi-mod(-s(2:3)',2*pi)));

Rfcn = @(s) - s'*s;


data = zeros(6,(Nt-1));
r = zeros(1,(Nt-1));
Qdata = zeros(1,(Nt-1));

at = zeros(1,(Nt-1));
amax = +5e2;
amin = -5e2;
aline = linspace(amin,amax,2);

eps = eps0;

alpha = 0.1;
gamma = 0.5;
%%

%%
epochs = 1;
clf
ax = axes; 
ylim([-5 10])
xlim([1 Nt])

indexs = 1:length(aline);
Qvalues = zeros(1,Nt);
for iepo = 1:epochs
   eps = eps0/iepo^(1/4);

   for it = 1:Nt-1
                   
       if eps > rand || it <= 2
            a= amax*2*(rand-0.5);
            [~,ind_action] = min(abs(a-aline));       
            a = aline(ind_action);
       else          
            Qa_fcn = @(a) Qvalues(argmin(arrayfun( @(j) norm([ mod(st(it,2:3),2*pi)  st(it,4:6) a] - [ mod(st(j,2:3),2*pi) st(j,4:6) at(j)]),1:it-1)));
            
            Qa_all = arrayfun(@(a) Qa_fcn(a),aline);
            [Qa_all_max,ind_action] = max(Qa_all);
            ind_action = randsample(indexs(Qa_all_max == Qa_all),1);
            
            
            a = aline(ind_action);
       end
       %

      dt = tspan(it+1) - tspan(it);
      %%
      st(it+1,:) = st(it,:) + dt*cartpole_dynamics(tspan(it),st(it,:)',a,params)';
      
      %%
      r(it) = Rfcn(st(it+1,:)');
        
      if isnan(r(it)) 
            break
      end
      at(it) = a;
        
      %% learning
      % max 
      if it <= 2
          Qvalues(it) = r(it);
      else
          Qa_fcn = @(a) Qvalues(argmin(arrayfun( @(j) norm([ mod(st(it+1,2:3),2*pi)  st(it+1,4:6) a] - [ mod(st(j,2:3),2*pi) st(j,4:6) at(j)]),1:it-1)));
          %Qa_fcn = @(a) Qvalues(argmin(arrayfun( @(j) norm([mod(st(it+1,:),2*pi) a] - [mod(st(j,:),2*pi) at(j)]),1:it-1)));
          Qvalues(it) = r(it) + gamma*max(arrayfun(@(a) Qa_fcn(a),aline));
      end
      %%
   end
   
   if mod(iepo,50) == 0
       hold on; 
       if exist('l1')
          l1.Color = [0.9 0.9 0.9];
       end
       l1 = line(1:it,mod(st(1:it,[3]),2*pi),'Parent',ax);
       pause(0.1)
   end
end


%%
fig = figure(1); cartpole_animation_several(fig,st,tspan,5.5)