function animation(iode,varargin)
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
% iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
% U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tspan)]
%    default:   empty
    p = inputParser;
    
    addRequired(p,'iode')
    addOptional(p,'YLim',[])
    addOptional(p,'YLimControl',[])
    addOptional(p,'Target',[])
    addOptional(p,'InitCondition',[])
    

    addOptional(p,'xx',1.0)
    addOptional(p,'SaveGif',false)
    
    parse(p,iode,varargin{:})
    
    YLim = p.Results.YLim;
    xx = p.Results.xx;
    SaveGif = p.Results.SaveGif;
    YLimControl = p.Results.YLimControl;
    Target = p.Results.Target;
    InitCondition = p.Results.InitCondition;
    
    structure = [iode.StateVector];
    Y = {structure.Numeric};
    structure = [iode.Control];
    U = {structure.Numeric};        
    f = figure;
    axY = subplot(2,1,1,'Parent',f);
    if ~isempty(YLim)
        axY.YLim = YLim;
    end
    axU = subplot(2,1,2,'Parent',f);
    if ~isempty(YLimControl)
        axU.YLim = YLimControl;
    end
    %
    tspan = iode.tspan;
        
    tic;
    tmax = tspan(end);
    
    [nrow ncol] = size(Y{1});
    
   
   if SaveGif
      numbernd =  num2str(floor(100000*rand),'%.6d');
      gif([numbernd,'.gif'],'frame',axY.Parent,'DelayTime',1/8)  
   end
   
   axY.XLabel.String = 'State';
   
   if ~isempty(InitCondition)
      line(iode(1).mesh,InitCondition,'Parent',axY,'Color','blue','LineWidth',1.5) 
   end
   
   if ~isempty(Target)
      line(iode(1).mesh,Target,'Parent',axY,'Color','green','LineWidth',1.5) 
   end
   
   
   axU.XLabel.String = 'Control';
   
   
   while true
        t = xx*toc;
        if t > tmax
            t = tmax;
        end
        if exist('l','var')
            delete(l)
            delete(luu)
        end
        axY.Title.String = ['t = ',num2str(t,'%.2f')];
        
        index = 0;
        colors = {'r','g','b'};
        LinS = {'-','--'};
        pt = {'.','.'};
        for iY = Y
            ic = mod(index,3) + 1;
            il = mod(index,2) + 1;
            ip = mod(index,2) + 1;
            index = index + 1;
              %if t == tmax
              %    l(index)   = line(iode(1).mesh,Target','Parent',axY,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);
              %else
                l(index)   = line(iode(1).mesh,interp1(tspan,iY{:},t),'Parent',axY,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);
              %end
            luu(index) = line(iode(1).mesh,interp1(tspan,U{index},t),'Parent',axU,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);
            
        end
        legend(axY,{'Initial datum','Target','State'})
        %legend(axU,{iode.label})
        pause(0.1)
        
        titlefig = strcat('sol_t_',num2str(t,'%.2f'));
        titlefig = replace(titlefig,'.','');
        titlefigup = strcat(titlefig,'_up.png');
        titlefigdown = strcat(titlefig,'_down.png');
        titlefigupC = strcat(titlefig,'_up_constrained.png');
        titlefigupCL = strcat(titlefig,'_up_constrained_tlarge.png');
        titlefigdownC = strcat(titlefig,'_down_constrained.png');
        titlefigdownCL = strcat(titlefig,'_down_constrained_tlarge.png');
        
        
        %print(titlefigdownCL,'-dpng','-r500')
        
        if SaveGif
            gif('frame',axY.Parent)
        end
        if t == tmax
            break;
        end
    end

end

