function plot(iCP,varargin)
% name: GradientMethod
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
%   iCP: 
%       name: Control Problem
%       description: 
%       class: ControlProblem
%       dimension: [1x1]
% OptionalInputs:
%   U0:
%       name: Initial Control 
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tline)]
%       default:

    p = inputParser;
    
    addRequired(p,'iCP',@iCP_valid)
    addOptional(p,'TypeGraphs','ODE')
    addOptional(p,'SaveGif',false)
    
    parse(p,iCP,varargin{:})
    
    SaveGif     = p.Results.SaveGif;
    TypeGraphs  = p.Results.TypeGraphs;
    
    nY = length(iCP.ode.Y0);
    nU = length(iCP.UOptimal(1,:));
    
    [axY,axU,axJ] = init_graphs(TypeGraphs,nY,nU,SaveGif);
    
    Jhistory = iCP.Jhistory;
    tline = iCP.ode.tline;
    for iter = 2:iCP.iter
        Ynew = iCP.Yhistory{iter};
        Unew = iCP.Yhistory{iter};
        bucle_graphs(axY,axU,axJ,Ynew,Unew,Jhistory,tline,iter,TypeGraphs,SaveGif)
    end
end



%% 
function [axY,axU,axJ] = init_graphs(TypeGraphs,nY,nU,SaveGif)
   f = figure;
   FontSize  = 14;
   set(f,'defaultuipanelFontSize',FontSize)
   Ypanel = uipanel('Parent',f,'Units','norm','Pos',[0.0 0.0 1/3 1.0],'Title','State');
   Upanel = uipanel('Parent',f,'Units','norm','Pos',[1/3 0.0 1/3 1.0],'Title','Control');
   Jpanel = uipanel('Parent',f,'Units','norm','Pos',[2/3 0.0 1/3 1.0],'Title','Functional Convergence');

   switch TypeGraphs
       case 'ODE'
           index = 0;
           for iY = 1:nY
              index = index + 1;
              axY{index} = subplot(nY,1,iY,'Parent',Ypanel);
              axY{index}.Title.String = ['Y_',num2str(index),'(t)'];
              axY{index}.XLabel.String = 't';
           end

           index = 0;
           for iU = 1:nU
              index = index + 1;
              axU{index} = subplot(nU,1,iU,'Parent',Upanel);
              axU{index}.Title.String = ['U_',num2str(index),'(t)'];
              axU{index}.XLabel.String = 't';
           end

       case 'PDE'
            axY = axes('Parent',Ypanel);
            axU = axes('Parent',Upanel);
   end
          
   axJ = axes('Parent',Jpanel);
   axJ.Title.String = 'J';
   axJ.XLabel.String = 'iter';
   
   if SaveGif
      numbernd =  num2str(floor(100000*rand),'%.6d');
      gif([numbernd,'.gif'],'frame',f,'DelayTime',1/2)  
   end

end

function bucle_graphs(axY,axU,axJ,Ynew,Unew,Jhistory,tline,iter,TypeGraphs,SaveGif)

    Color = {'r','g','b','y','k','c'};
    
    switch TypeGraphs
        case 'ODE'
            iter_graph = 0;
            for iy = Ynew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tline,iy,'Parent',axY{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axY{iter_graph}.Children) > 1
                    axY{iter_graph}.Children(2).Color = 0.25*(3+axY{iter_graph}.Children(2).Color);
                    axY{iter_graph}.Children(2).Marker = 'none';


                end
            end

            iter_graph = 0;
            for iu = Unew
                iter_graph = iter_graph + 1;
                index_color = 1+ mod(iter_graph-1,length(Color));
                line(tline,iu,'Parent',axU{iter_graph},'Color',Color{index_color},'LineStyle','-','Marker','.')
                if length(axU{iter_graph}.Children) > 1
                    axU{iter_graph}.Children(2).Color =  0.25*(3+axU{iter_graph}.Children(2).Color);
                    axU{iter_graph}.Children(2).Marker = 'none';

                end
            end                  
        case 'PDE'
            line(1:length(Ynew(end,:)),Ynew(end,:),'Parent',axY,'Marker','.')
            if length(axY.Children) > 1
                    axY.Children(2).Color =  0.25*(3+axY.Children(2).Color);
                    axY.Children(2).Marker = 'none';
            end  
            
            line(1:length(Unew(end,:)),Unew(end,:),'Parent',axU,'Marker','.')                       
            if length(axU.Children) > 1
                    axU.Children(2).Color =  0.25*(3+axU.Children(2).Color);
                    axU.Children(2).Marker = 'none';
            end
             
            
    end


    line(0:(iter-1),Jhistory(1:iter),'Parent',axJ,'Color','b','Marker','s')

    if SaveGif
       f = axJ.Parent.Parent;
       gif('frame',f)
    end
end


function iCP_valid(iCP)
    if isempty(iCP.UOptimal)
        error('The Control proble must be solve before to plot graphs.')
    end
end
