function bucle_graphs_gradientmethod(axes,iCP,iter)
    
    axY = axes.axY;
    axU = axes.axU;
    axJ = axes.axJ;

    Ynew = iCP.Solution.Yhistory{iter};
    Unew = iCP.Solution.ControlHistory{iter};
    tspan = iCP.Dynamics.tspan;
    
    Jhistory = iCP.Solution.Jhistory(1:iter);

    TypeGraphs = class(iCP.Dynamics);
    live = true;
    SaveGif = false;
    %axY,axU,axJ,
    % Ynew,Unew,Jhistory,tspan,iter,TypeGraphs,SaveGif,live

    Color = {'r','g','b','y','k','c'};
    
    switch TypeGraphs
        case 'ode'
            iter_graph = 0;
            for iy = Ynew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tspan,iy,'Parent',axY{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axY{iter_graph}.Children) > 1
                    axY{iter_graph}.Children(2).Color = 0.25*(3+axY{iter_graph}.Children(2).Color);
                    axY{iter_graph}.Children(2).Marker = 'none';


                end
            end

            iter_graph = 0;
            for iu = Unew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tspan,iu,'Parent',axU{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axU{iter_graph}.Children) > 1
                    axU{iter_graph}.Children(2).Color =  0.25*(3+axU{iter_graph}.Children(2).Color);
                    axU{iter_graph}.Children(2).Marker = 'none';

                end
            end                  
        case 'pde'
            
            nspace = length(Ynew(1,:));
            ntime  = length(tspan);
            
            ninterspace = floor(nspace/80);
            nintertime  = floor(ntime/80);
            if ninterspace ~= 0 && nintertime ~= 0
                Ynew = Ynew(1:nintertime:ntime,1:ninterspace:nspace);
                Unew = Unew(1:nintertime:ntime,1:ninterspace:nspace);
            elseif  ninterspace ~= 0 && nintertime == 0
                Ynew = Ynew(:,1:ninterspace:nspace);
                Unew = Unew(:,1:ninterspace:nspace);                
            elseif ninterspace == 0 && nintertime ~= 0
                Ynew = Ynew(1:nintertime:ntime,:);
                Unew = Unew(1:nintertime:ntime,:);  
            end
            
            line(1:length(Ynew(end,:)),Ynew(end,:),'Parent',axY{1},'Marker','.')
            if length(axY{1}.Children) > 1
                    axY{1}.Children(2).Color =  0.25*(3+axY{1}.Children(2).Color);
                    axY{1}.Children(2).Marker = 'none';
            end  
            
            

            
            surf(Ynew','Parent',axY{2})
            axY{2}.Title.String = 'Evolution of State Vector ';
            axY{2}.YLabel.String = 'Space';
            axU{2}.XLabel.String = 'Time';

            line(1:length(Unew(end,:)),Unew(end,:),'Parent',axU{1},'Marker','.')                       
            if length(axU{1}.Children) > 1
                    axU{1}.Children(2).Color =  0.25*(3+axU{1}.Children(2).Color);
                    axU{1}.Children(2).Marker = 'none';
            end
 
            
            surf(Unew','Parent',axU{2})
            axU{2}.Title.String = 'Evolution of Control Vector ';
            axU{2}.YLabel.String = 'Space';
            axU{2}.XLabel.String = 'Time';
            if live
            pause(0.01)
            end
    end

    inititer = 0;
    
    line(inititer:(iter-1),Jhistory((1+inititer):iter),'Parent',axJ{1},'Color','b','Marker','s')

    if iter > 50
        axJ{2}.XLim = axJ{2}.XLim + 1; 
    end
    
    line(inititer:(iter-1),Jhistory((1+inititer):iter),'Parent',axJ{2},'Color','b','Marker','s')
    
    if SaveGif
       f = axJ.Parent.Parent;
       gif('frame',f)
    end
    pause(0.1)
end
