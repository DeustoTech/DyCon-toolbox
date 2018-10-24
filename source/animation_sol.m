function animation_sol(solutions,uhistory,varargin)
%ANIMATION_SOL Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    addRequired(p,'solutions')
    addRequired(p,'uhistory')
    addOptional(p,'figure',[])
    addOptional(p,'XLim',[])
    addOptional(p,'ULim',[])
    addOptional(p,'SaveGif',false)
    addOptional(p,'path','')
    addOptional(p,'dt',0.15)

    
    parse(p,solutions,uhistory,varargin{:})
       
    fig  = p.Results.figure;
    XLim = p.Results.XLim;
    ULim = p.Results.ULim;
    SaveGif  = p.Results.SaveGif;
    path = p.Results.path;
    dt = p.Results.dt;
    
    if isempty(fig)
        fig = figure;
    end
    
    %% Define axis 1  
    ax1  = subplot(2,1,1,'Parent',fig);
    
    ax1.XLabel.String = 't';
    ax1.YLabel.String = 'x_{i}(t)';
    ax1.Title.String = 'Evolution of mean vector state';
    if ~isempty(XLim)
        ax1.YLim = XLim;
    end
        
    
    %% Define axis 2  
    ax2  = subplot(2,1,2,'Parent',fig);
    ax2.XLabel.String = 't';
    ax2.YLabel.String = 'u(t)';    
    if ~isempty(ULim)
        ax2.YLim = ULim;
    end
    format_plot(fig)

    N = length(solutions{1}(1,:)) - 1;

    %% plot in ax1, vector states 
    mt = solutions{1};
    lin1 = line(mt(:,1),mt(:,2:end),'Parent',ax1);
    %% plot in ax2, control 
    u = uhistory{1};
    lin2 = line(u(:,1),u(:,2),'Parent',ax2);
    
    iter = 0;
    
    if SaveGif
        gif([path,'average_control.gif'],'DelayTime',0.1,'LoopCount',5,'frame',fig)
    end
    for isol = solutions
        if SaveGif   
            gif
        end
        iter = iter + 1;
        %
        mt = isol{:};
        delete(lin1)
        lin1 = line(mt(:,1),mt(:,2:end),'Parent',ax1);
        %
        u = uhistory{iter};
        delete(lin2)
        lin2 = line(u(:,1),u(:,2),'Parent',ax2);
        %
        %cellnames = cellstr(strcat('x_{',num2str((1:N)','%0.1d'),'}(t)'))'
        ax2.Title.String = ['Control  - Iteration: ',num2str(iter)];
        pause(dt)
        if ~isvalid(fig)
            return
        end
    end
end

