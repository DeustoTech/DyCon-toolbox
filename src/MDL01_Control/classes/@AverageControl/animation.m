function animation(iAverageProblem,varargin)
%ANIMATION_SOL Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    addRequired(p,'iAverageProblem')
    addOptional(p,'figure',[])
    addOptional(p,'XLim',[])
    addOptional(p,'ULim',[])
    addOptional(p,'JLim',[])
    addOptional(p,'SaveGif',false)
    addOptional(p,'path','')
    addOptional(p,'dt',0.15)

    
    parse(p,iAverageProblem,varargin{:})
       
    fig  = p.Results.figure;
    XLim = p.Results.XLim;
    ULim = p.Results.ULim;
    JLim = p.Results.JLim;
    SaveGif  = p.Results.SaveGif;
    path = p.Results.path;
    dt = p.Results.dt;
    

    %%
    solutions = iAverageProblem.addata.xhistory;
    uhistory  = iAverageProblem.addata.uhistory;
    Jhistory  = iAverageProblem.addata.Jhistory;
    if isempty(fig)
        fig = figure('Units','normalized');
        fig.Position(2) = 0.05;
        fig.Position(4) = fig.Position(4) + 0.15;
        
    end
    
    %% Define axis 1  
    ax1  = subplot(3,1,1,'Parent',fig);
    
    ax1.XLabel.String = 't';
    ax1.YLabel.String = 'x_{i}(t)';
    ax1.Title.String = 'Evolution of mean vector state';
    if ~isempty(XLim)
        ax1.YLim = XLim;
    end
        
    
    %% Define axis 2  
    ax2  = subplot(3,1,2,'Parent',fig);
    ax2.XLabel.String = 't';
    ax2.YLabel.String = 'u(t)';    
    if ~isempty(ULim)
        ax2.YLim = ULim;
    end
    %% Define axis 3
    ax3  = subplot(3,1,3,'Parent',fig);
    ax3.Title.String = 'Functional Convergence';
    ax3.XLabel.String = 'iter';
    ax3.YLabel.String = 'J';    
    ax3.XLim = [0,length(Jhistory)];
    if ~isempty(JLim)
        ax3.YLim = JLim;
    end    
    
    %% plot in ax1, vector states 
    mt = solutions{1};
    lin1 = line(mt(:,1),mt(:,2:end),'Parent',ax1);
    %% plot in ax2, control 
    u = uhistory{1};
    lin2 = line(u(:,1),u(:,2),'Parent',ax2);
    %% plot in ax3, J functional 
    lin3 = line(1,Jhistory(1),'Parent',ax3);
    
    iter = 0;
    
    if SaveGif
        gif([path,'average_control.gif'],'DelayTime',0.1,'LoopCount',5,'frame',fig)
    end
    
    for isol = solutions
        if SaveGif   
            gif
        end
        iter = iter + 1;
        %%
        mt = isol{:};
        delete(lin1)
        lin1 = line(mt(:,1),mt(:,2:end),'Parent',ax1);
        %%
        u = uhistory{iter};
        delete(lin2)
        lin2 = line(u(:,1),u(:,2),'Parent',ax2);
        %
        %cellnames = cellstr(strcat('x_{',num2str((1:N)','%0.1d'),'}(t)'))'
        ax2.Title.String = ['Control  - Iteration: ',num2str(iter)];
        %%
        delete(lin3)
        lin3 = line(1:iter,Jhistory(1:iter),'Parent',ax3,'Marker','o','LineStyle','-');

        pause(dt)
        if ~isvalid(fig)
            return
        end
    end
end

