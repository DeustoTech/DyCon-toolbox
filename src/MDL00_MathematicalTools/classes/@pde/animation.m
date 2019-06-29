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
    addOptional(p,'LogControl',false)

    addOptional(p,'Target',[])
    addOptional(p,'InitCondition',[])
    addOptional(p,'ControlShadow',false)

    addOptional(p,'FontSize',12)

    addOptional(p,'xx',1.0)
    addOptional(p,'SaveGif',false)
    addOptional(p,'SaveVideo',false)
    
    parse(p,iode,varargin{:})
    
    YLim            = p.Results.YLim;
    xx              = p.Results.xx;
    SaveGif         = p.Results.SaveGif;
    SaveVideo         = p.Results.SaveVideo;

    YLimControl     = p.Results.YLimControl;
    Target          = p.Results.Target;
    InitCondition   = p.Results.InitCondition;
    ControlShadow    = p.Results.ControlShadow;
    LogControl      = p.Results.LogControl;
    structure       = [iode.StateVector];
    Y               = {structure.Numeric};
    structure       = [iode.Control];
    U               = {structure.Numeric};        
    f = figure('unit','norm','pos',[0.1 0.1 0.8 0.8]);
    FontSize = p.Results.FontSize;
   
    itext = uicontrol('style','text','Parent',f,'unit','norm','pos',[0.45 0.95 0.1 0.03]);
    itext.FontSize = FontSize;
   itext.FontWeight = 'bold';   
    havecontrol = ~isempty(iode(1).Control.Symbolic);
    
    if havecontrol
        axY = subplot(1,2,1,'Parent',f);
        axY.FontSize = FontSize;

        if ~isempty(YLim)
            axY.YLim = YLim;
        end
        axU = subplot(1,2,2,'Parent',f);
        axU.FontSize = FontSize;

        if ~isempty(YLimControl)
            axU.YLim = YLimControl;
        end
    else
        axY = subplot(1,1,1,'Parent',f);
        if ~isempty(YLim)
            axY.YLim = YLim;
        end
    end
    %
    tspan = iode.tspan;
        
    tic;
    tmax = tspan(end);
        
   
   if SaveGif
      numbernd =  num2str(floor(100000*rand),'%.6d');
      gif([numbernd,'.gif'],'frame',axY.Parent,'DelayTime',1/8)  
   end
   
   if SaveVideo
      numbernd =  num2str(floor(100000*rand),'%.6d');
      ivd = VideoWriter(numbernd,'mp4');
      ivd.FrameRate = 10;

      open(ivd)
   end
   axY.XLabel.String = 'State';
   
   legend_string = {};
   int_ls = 0;
   if ~isempty(InitCondition)
      line(iode(1).mesh,InitCondition,'Parent',axY,'Color','blue','LineWidth',1.5) 
      int_ls = int_ls + 1;
      legend_string{int_ls} = 'Initial datum';
   end
   
   if ~isempty(Target)
      line(iode(1).mesh,Target,'Parent',axY,'Color',[0.4 0.3 0.6],'LineWidth',1.5) 
      int_ls = int_ls + 1;
      legend_string{int_ls} = 'Target';
   end
   
   int_ode = 0;
   for iiode = iode
       int_ode = int_ode + 1;
       int_ls = int_ls + 1;
       if isempty(iiode.label)
            legend_string{int_ls} = "dynamics - "+ int_ode;      
       else
            legend_string{int_ls} = iiode.label;
       end
   end

   axU.XLabel.String = 'Control';
   
   
   BarPrograss = axes('Parent',f,'Unit','norm','pos',[0.01 0.01 0.98 0.015]);
   axis(BarPrograss,'off')
   BarPrograss.XLim = [0 1];
   BarPrograss.YLim = [0 1];
   rectangle('Parent',BarPrograss)
   irect = patch('XData',[0 1 1 0],'YData',[0 0 1 1]);
   irect.FaceColor = [1 0 0];


   first = true;
   while true
        if first
            t = 0;
            first = false;
        else
            t = xx*toc;
        end
        if t > tmax
            t = tmax;
        end
        if exist('l','var')
            delete(l)
        end
        if havecontrol && ~ControlShadow
            if exist('luu','var')
                delete(luu) 
            end
        end
        itext.String = ['time = ',num2str(t,'%.2f')];
        
        index = 0;
        colors = {'r','g','b'};
        LinS = {'-','--'};
        pt = {'.','.'};
        for iY = Y
            ic = mod(index,3) + 1;
            il = mod(index,2) + 1;
            ip = mod(index,2) + 1;
            index = index + 1;
   
            l(index)   = line(iode(1).mesh,interp1(tspan,iY{:},t),'Parent',axY,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);
            if ~isempty(U{index})
                if ControlShadow && exist('luu','var')
                    luu(index).Color = 0.2*luu(index).Color + 0.8*[1 1 1];
                end
                if LogControl
                   Udata =  log10(U{index} + 1);
                else
                   Udata =  U{index};

                end
                luu(index) = line(1:iode(1).ControlDimension,interp1(tspan,Udata,t),'Parent',axU,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);
                %luu(index) = line(iode(1).mesh,interp1(tspan,U{index},t),'Parent',axU,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic},'LineWidth',1.5);

            end
        end
        
        legend(axY,legend_string)
        
        %%
       irect_time = t/tmax;
       irect.XData(2) = irect_time;
       irect.XData(3) = irect_time;
   
        %legend(axU,{iode.label})
        pause(0.1)
        

        if SaveGif
            gif('frame',axY.Parent)
        end
        
        if SaveVideo
           writeVideo(ivd,getframe(axY.Parent)) 
        end
        if t == tmax
            break;
        end
   end

    if SaveGif
    for iter = 1:10 
        pause(0.1)
        gif('frame',axY.Parent)
    end
    end
    
    if SaveVideo
       close(ivd) 
    end
end

