clear
close all
%% Discretization Paramters
Nt = 25;
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
Ts = linspace(0.02,2,50);

figure('unit','norm','pos',[0 0 1 1])
axs = {};
M = 6;
for i = 1:M
axs{i} = subplot(2,M/2,i);
end
%
u0 = 10*sin(pi*xline');


for iT = Ts
    %
    THs = [0 0.1 0.25 0.5 0.75 1];
    iter = 0;
    for iThs = THs 
        if iThs < 0.5
            Nt = floor(4*2*(1-2*iThs)*iT/dx^2);
        else
            Nt = 50;
        end
        tspan = linspace(0,iT,Nt);

        iter = iter + 1;
        tic
        ut = thetasolver(u0,A,b,tspan,iThs);
        time = toc;
        surf(tspan,xline,ut,'Parent',axs{iter})
        shading(axs{iter},'interp')
        xlim(axs{iter},[0 Ts(end)])
        zlim(axs{iter},[-10 20])
        title(axs{iter},"T = "+num2str(iT,'%.2f') + " | N_t = " + Nt + " | t_{exc} = "+num2str(time,'%.2E'))
    end
    %
    pause(0.2)
end
%%
