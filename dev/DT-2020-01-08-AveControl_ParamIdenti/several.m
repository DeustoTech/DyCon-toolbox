clear
load('free1.mat')
st1 = st;
load('free2.mat')
st2 = st;


figure(6)
clf
ax1 = subplot(1,2,1); xlim(ax1,[-3 3]);ylim(ax1,[-3 3])
title('\theta_2 = 0.1')
gc_1 = graph_cartpole(ax1,st1);
ax2 = subplot(1,2,2); xlim(ax2,[-3 3]);ylim(ax2,[-3 3])
title('\theta_2 = 0.05')
gc_2 = graph_cartpole(ax2,st2);


[Nt,~] = size(st);
pause(1)
for it = 1:Nt-1
   step(gc_1)
  step(gc_2)
pause(0.03)
end

%%

clear
load('control.mat')
st1 = st;

figure(6)
clf
ax1 = axes;; xlim(ax1,[-6 6]);ylim(ax1,[-3 3])
daspect([1 1 1])
gc_1 = graph_cartpole(ax1,st1);



[Nt,~] = size(st);
pause(1)
for it = 1:Nt-1
   step(gc_1)
pause(0.03)
end


%%
clear
clf
load('control2020213122414.388629.mat')
stt{1} = st;
load('control2020213122355.99346.mat')
stt{2} = st;
load('control2020213122345.931765.mat')
stt{3} = st;
load('control2020213122332.901827.mat')
stt{4} = st;
load('control202021312245.54095.mat')
stt{5} = st;
load('control2020213123254.241056.mat')
stt{6} = st;
[Nt,~] = size(st);


for i = 1:6
    axs{i} = subplot(2,3,i); 
    xlim(axs{i} ,[-3 3]);ylim(axs{i} ,[-3 3])
    gc{i} = graph_cartpole(axs{i},stt{i});
end

%
for it = 1:Nt-1
    for i = 1:6
        step(gc{i})
    end
    pause(0.03)
end


