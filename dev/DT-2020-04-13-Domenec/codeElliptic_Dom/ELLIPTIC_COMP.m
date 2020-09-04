



MU=[0.100 0.050 0.020 0.010 0.005 0.003 0.001 0.0003 0.0002 0.0001 0.0005];
MU=[0.100 0.050 0.020 0.010 0.005 0.003 0.001 0.0003 0.0002 0.0001];

for i=1:length(MU)
    mu=MU(i);
    Nx2=35;
    %from 1000 to 2000
    [y2,m2]=gradientElliptic(mu,2,Nx2,1,0.6,1);
    Dy2{i}=y2; Dm2{i}=m2;
    

    fy2=figure
        surf(y2)
        colormap('jet');
        colorbar
        caxis([0 1]);
        shading interp;
        view(2);
        set(gca,'FontSize',15)
        xlim([1 Nx2]);
        ylim([1 Nx2]);
        xticks([1 Nx2/2 Nx2]);
        xticklabels({'0','0.5' '1'});
        yticks([1 Nx2/2 Nx2]);
        yticklabels({'0','0.5' '1'});
        xlabel('$x$','interpreter','latex','fontsize',20')
        ylabel('$y$','interpreter','latex','fontsize',20')
        title(strcat('Elliptic optimum, $\int\theta=$',num2str(round(sum(sum(y2))*(1/Nx2)^2,3)),', $\mu=$',num2str(mu)),'interpreter','latex','fontsize',17);
        set(fy2,'PaperSize',[6 5]);
        print(fy2,strcat('d2EllState',num2str(i),'.pdf'),'-dpdf');

    fm2=figure
        surf(m2)
        colormap('jet');
        colorbar
        caxis([0 1]);
        shading interp;
        view(2);
        set(gca,'FontSize',15)
        xlim([1 Nx2]);
        ylim([1 Nx2]);
        xticks([1 Nx2/2 Nx2]);
        xticklabels({'0','0.5' '1'});
        yticks([1 Nx2/2 Nx2]);
        yticklabels({'0','0.5' '1'});
        xlabel('$x$','interpreter','latex','fontsize',20')
        ylabel('$y$','interpreter','latex','fontsize',20')
        title(strcat('Resources, $\mu=$',num2str(mu)),'interpreter','latex','fontsize',17);
        set(fm2,'PaperSize',[6 5]);
        print(fm2,strcat('d2Ellm',num2str(i),'.pdf'),'-dpdf');



end

