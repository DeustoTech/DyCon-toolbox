function graphs_iter_GBR(axes,iCP,iter)
%INIT_SHEEP_DOG Summary of this function goes here
%   Detailed explanation goes here
    SaveGif = false;

    axY = axes.axY;
    axU = axes.axU;
    axJ = axes.axJ;
    
    global N M u_f Nt

    YO_tline = iCP.Solution.Yhistory{iter};
    UO_tline = iCP.Solution.ControlHistory{iter};
    %tline = iCP.Dynamics.tspan;
    %tline_UO = 1/(Nt-1)*cumtrapz(UO_tline(:,end));
    tline_UO = iCP.Dynamics.tspan;
    
    Jhistory = iCP.Solution.Jhistory(1:iter);

    %TN = length(tline);
    % Cost calcultaion

    ue_tline = reshape(YO_tline(:,1:2*N),[Nt 2 N]);
    %ve_tline = reshape(YO_tline(:,2*N+1:4*N),[TN 2 N]);
    ud_tline = reshape(YO_tline(:,4*N+1:4*N+2*M),[Nt 2 M]);
    %vd_tline = reshape(YO_tline(:,4*N+2*M+1:4*M+4*N),[TN 2 M]);

delete(axY{1}.Children)
line(ud_tline(:,1,1),ud_tline(:,2,1),'Parent',axY{1},'Color','b','LineStyle','-','LineWidth',0.5,'Marker','none')
line(ue_tline(:,1,1),ue_tline(:,2,1),'Parent',axY{1},'Color','r','LineStyle','-','LineWidth',0.5,'Marker','none')
%
line(ud_tline(end,1,1),ud_tline(end,2,1),'Parent',axY{1},'Color','b','LineStyle','-','LineWidth',0.5,'Marker','o')
line(ue_tline(end,1,1),ue_tline(end,2,1),'Parent',axY{1},'Color','r','LineStyle','-','LineWidth',0.5,'Marker','o')
%
for k=2:M
    line(ud_tline(:,1,k),ud_tline(:,2,k),'Parent',axY{1},'Color','b','LineStyle','-','LineWidth',0.5,'Marker','none')
    line(ud_tline(end,1,k),ud_tline(end,2,k),'Parent',axY{1},'Color','b','LineStyle','-','LineWidth',0.5,'Marker','o')

end
for k=2:N
    line(ue_tline(:,1,k),ue_tline(:,2,k),'Parent',axY{1},'Color','r','LineStyle','-','LineWidth',0.5,'Marker','none')
    line(ue_tline(end,1,k),ue_tline(end,2,k),'Parent',axY{1},'Color','r','LineStyle','-','LineWidth',0.5,'Marker','o')

end
line(u_f(1),u_f(2),'Parent',axY{1},'Color','k','Marker','s','MarkerSize',20)
% for k=1:M
% line(tline_UO,UO_tline(:,k),'Parent',axU{1},'Marker','.')   
% end
% if length(axU{1}.Children) > 1
%     axU{1}.Children(2).Color =  0.25*(3+axU{1}.Children(2).Color);
%     axU{1}.Children(2).Marker = 'none';
% end

    iter_graph = 0;
    for iter_graph = 1:M
        line(tline_UO,UO_tline(:,iter_graph),'Parent',axU{iter_graph},'LineStyle','-','Marker','.')
        if length(axU{iter_graph}.Children) > 1
            axU{iter_graph}.Children(2).Color =  0.25*(3+axU{iter_graph}.Children(2).Color);
            axU{iter_graph}.Children(2).Marker = 'none';
        end
    end  

    inititer = 0;
    
    line(inititer:(iter-1),Jhistory((1+inititer):iter),'Parent',axJ{1},'Color','b','Marker','s')

    if iter > 50
        axJ{2}.XLim = axJ{2}.XLim + 20; 
    end
    
    line(inititer:(iter-1),Jhistory((1+inititer):iter),'Parent',axJ{2},'Color','b','Marker','s')
    
    if SaveGif
       f = axJ.Parent.Parent;
       gif('frame',f)
       
    end
    pause(0.001)
end

