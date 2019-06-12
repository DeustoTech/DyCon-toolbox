function graphs_iter_sheep_dog(axes,iCP,iter)
%INIT_SHEEP_DOG Summary of this function goes here
%   Detailed explanation goes here

    global N M u_f

    YO_tline = iCP.Solution.Yhistory{iter};
    UO_tline = iCP.Solution.ControlHistory{iter};
    tline = iCP.Dynamics.tspan;
    tline_UO = UO_tline(end);
    
    Jhistory = iCP.Solution.Jhistory(1:iter);

    TN = length(tline);
    % Cost calcultaion

    ue_tline = reshape(YO_tline(:,1:2*N),[TN 2 N]);
    %ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
    ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[TN 2 M]);
    %vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);

delete(axes(1).Children)
    line(ud_tline(:,1,1),ud_tline(:,2,1),'Color','b','LineStyle','-','LineWidth',1.0,'Parent',axes(1));
    line(ue_tline(:,1,1),ue_tline(:,2,1),'Color','r','LineStyle','-','LineWidth',1.3,'Parent',axes(1));
    for k=2:N
      line(ue_tline(:,1,k),ue_tline(:,2,k),'Color','r','LineStyle','-','LineWidth',1.3,'Parent',axes(1));
    end
    for k=2:M
      line(ud_tline(:,1,k),ud_tline(:,2,k),'Color','b','LineStyle','-','LineWidth',1.0,'Parent',axes(1));
    end
    
    legend('Drivers','Evaders','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')
%ylim([-2.5 1.5])
title(['Total Cost = ',num2str(Jhistory(end))])
grid on

    pause(0.5)
end

