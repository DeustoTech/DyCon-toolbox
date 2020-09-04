function plotell(y,m,Nx,mu)

    
        subplot(2,1,1)
        surf(y)
        colormap('jet');
        colorbar
        caxis([0 1]);
        shading interp;
        view(2);
        set(gca,'FontSize',8)
        xlim([1 Nx]);
        ylim([1 Nx]);
        xticks([1 Nx/2 Nx]);
        xticklabels({'0','0.5' '1'});
        yticks([1 Nx/2 Nx]);
        yticklabels({'0','0.5' '1'});
        xlabel('$x$','interpreter','latex','fontsize',9')
        ylabel('$y$','interpreter','latex','fontsize',9')
        title(strcat('Elliptic optimum, $\int\theta=$',num2str(round(sum(sum(y))*(1/Nx)^2,3)),', $\mu=$',num2str(mu)),'interpreter','latex','fontsize',9);


        subplot(2,1,2)
        surf(m)
        colormap('jet');
        colorbar
        caxis([0 1]);
        shading interp;
        view(2);
        set(gca,'FontSize',12)
        xlim([1 Nx]);
        ylim([1 Nx]);
        xticks([1 Nx/2 Nx]);
        xticklabels({'0','0.5' '1'});
        yticks([1 Nx/2 Nx]);
        yticklabels({'0','0.5' '1'});
        xlabel('$x$','interpreter','latex','fontsize',9')
        ylabel('$y$','interpreter','latex','fontsize',9')
        title(strcat('Resources, $\mu=$',num2str(mu)),'interpreter','latex','fontsize',9);


        
end

