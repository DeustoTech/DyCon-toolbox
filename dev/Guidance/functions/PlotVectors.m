function PlotVectors(ud,uem,ut)
    clf
    hold on
    xmax = max([ud(1),uem(1),ut(1)]) + 2;
    ymax = max([ud(1),uem(2),ut(2)]) + 2;
    %
    xmin = min([ud(1),uem(1),ut(1)]) - 2;
    ymin = min([ud(2),uem(2),ut(2)]) - 2;
 

    

    plot([ud(1) ut(1) uem(1)],[ud(2) ut(2) uem(2)],'Marker','.','MarkerSize',30,'LineStyle','none')
    plot([uem(1)],[uem(2)],'Marker','o','MarkerSize',20,'LineStyle','none')

    xlim([xmin xmax])
    ylim([ymin ymax])
 
    rt = quiver(uem(1),uem(2),-uem(1)+ut(1),-uem(2)+ut(2),0,'MaxHeadSize',0.3,'LineWidth',1.5,'Color','g');
    rd = quiver(ud(1),ud(2),uem(1)-ud(1),uem(2)-ud(2),0,'MaxHeadSize',0.3,'LineWidth',1.5,'Color','g');

    opts = {'FontSize',19,'Interpreter','latex','Position',[100 100]};
    %
    rt_text   = text(0.5*uem(1) + 0.5*ut(1),0.5*uem(2) + 0.5*ut(2)  ,'$\vec{r}_t$'   ,opts{:});
    rd_text   = text(0.5*uem(1) + 0.5*ud(1),0.5*uem(2) + 0.5*ud(2)  ,'$\vec{r}_d$'   ,opts{:});
    %
    ud_text   = text(ud(1),ud(2)  ,'$u_d$'   ,opts{:});
    ut_text   = text(ut(1),ut(2)  ,'$u_t$'   ,opts{:});
    uem_text  = text(uem(1),uem(2),'$u_{em}$',opts{:});

    daspect([1 1 1])
    
    xline = linspace(-4,4,100);
    
    rect = @(x,a,b) -(a(2)-b(2))*(x-a(1))/(b(1)-a(1)) + a(2);
    prect = @(x,a,b) (a(1)-b(1))*(x-b(1))/(b(2)-a(2)) + b(2);
    
    plot(xline,rect(xline,uem,ut),'--','Color',[1 0.6 0.6])
    plot(xline,prect(xline,uem,ut),'--','Color',[1 0.6 0.6])

    plot(xline, rect(xline,uem,ud),'--','Color',[0.6 0.6 1])
    plot(xline,prect(xline,uem,ud),'--','Color',[0.6 0.6 1])   
end

