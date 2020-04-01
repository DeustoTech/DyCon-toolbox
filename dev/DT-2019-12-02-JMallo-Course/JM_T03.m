clear
close all
%% Discretization Paramters
Nt = 25;
Nx = 20;
xline = linspace(-1,1,Nx+2);
xline = xline(2:end-1);
%
%%
b = 0.75*exp(-(xline'/0.5).^2);
%clf
%plot(xline,b)% 
%title('source')
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
    tspan = linspace(0,iT,Nt);
    %
    THs = [0 0.1 0.25 0.5 0.75 1];
    iter = 0;
    for iThs = THs 
        iter = iter + 1;
        ut = thetasolver(u0,A,b,tspan,iThs);
        surf(tspan,xline,ut,'Parent',axs{iter})
        shading(axs{iter},'interp');lightangle(axs{iter},10,10)
        xlim(axs{iter},[0 Ts(end)])
        zlim(axs{iter},[-10 10])
        caxis(axs{iter},[-10 10])

        title(axs{iter},"\theta = "+iThs + " | T = "+num2str(iT,'%.2f') + " | Nt = "+Nt)
    end
    %
    pause(0.1)
end
%%
