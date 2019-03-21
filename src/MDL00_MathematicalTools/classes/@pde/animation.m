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

    addOptional(p,'xx',1.0)
    addOptional(p,'SaveGif',false)
    
    parse(p,iode,varargin{:})
    
    YLim = p.Results.YLim;
    xx = p.Results.xx;
    SaveGif = p.Results.SaveGif;
    YLimControl = p.Results.YLimControl;
    Target = p.Results.Target;
    
    structure = [iode.StateVector];
    Y = {structure.Numeric};
    structure = [iode.Control];
    U = {structure.Numeric};        
    f = figure;
    axY = subplot(1,2,1,'Parent',f);
    if ~isempty(YLim)
        axY.YLim = YLim;
    end
    axU = subplot(1,2,2,'Parent',f);
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
   
   axY.XLabel.String = 'Space';
   axY.YLabel.String = 'State';
   
   if ~isempty(Target)
      line(iode(1).mesh,Target,'Parent',axY) 
   end
   
   
   axU.XLabel.String = 'Space';
   axU.YLabel.String = 'Control';
   
   
   while true
        t = xx*toc;
        if t > tmax
            break
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
            l(index)   = line(iode(1).mesh,interp1(tspan,iY{:},t),'Parent',axY,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic});
            luu(index) = line(iode(1).mesh,interp1(tspan,U{index},t),'Parent',axU,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic});

        end
        legend(axU,{iode.label})
        pause(0.1)
        if SaveGif
            gif('frame',axY.Parent)
        end
    end

end

