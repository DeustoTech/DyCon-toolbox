clear
close all
%% Discretization Paramters
Nx = 100;
xline = linspace(-1,1,Nx+2);
xline = xline(2:end-1);
dx = xline(2) - xline(1);
%
%%
b = 20*exp(-(xline'/0.25).^2);
close all
plot(xline,b)% 
title('source')
%%
A = FDLaplacian(xline);
%%
Ts = linspace(0.02,5,6);

figure('unit','norm','pos',[0 0 1 1])
axs = {};
M = 6;
for i = 1:M
axs{i} = subplot(2,M/2,i);
end
%
u0 = 10*sin(pi*xline');

Nt = 10;
iter = 0;
for iT = Ts
    %
    iter = iter + 1;
    tic
    %% ode 45
    [tspan,ut] = ode45(@(t,u) A*u + b,[0 iT],u0);
    %% Theta = 1
    %tspan = linspace(0,iT,100);
    %ut = thetasolver(u0,A,b,tspan,1);
    %ut = ut';
    %%
    time = toc;
    surf(tspan,xline,ut','Parent',axs{iter})
        shading(axs{iter},'interp')
    xlim(axs{iter},[0 Ts(end)])
    zlim(axs{iter},[-10 20])
    title(axs{iter},"Nt = "+length(tspan) + " | T = "+num2str(iT,'%.2f') + " | t_{exc} = "+num2str(time,'%.2E'))
    %
end
%%
