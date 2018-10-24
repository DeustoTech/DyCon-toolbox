function  animation(xline,tline,u,varargin)
%% author: JesusO
%% short_description: This function can be show the evolution in real-time of solution of a unidimensional-solution  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Show animation of u evolution. View the                           %%%%
    %%%%                                                                   %%%%
    %%%%                                                                   %%%%
    %%%% J. Oroya, Sep 2018                                                %%%%
    %%%% v. 0.0                                                            %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Input vars:
    %
    %       -  xline   :: List of points in x-axis          
    %       -  tline   : List of points in t-axis
    %       -  u       : Solution of Schrodinger
    %   Optionals
    %   ---------
    %       -
    %% Output Vars:
    %
    %       -  x       : Space partition
    %       -  t       : Time partition
    %
    p = inputParser;
    
    addRequired(p,'xline')
    addRequired(p,'tline')
    addRequired(p,'u')

    addOptional(p,'xx',1.0)  
    addOptional(p,'SaveGif',false)
    addOptional(p,'path','')
    
    parse(p,xline,tline,u,varargin{:})
    
    xx      = p.Results.xx;
    SaveGif = p.Results.SaveGif;
    path    = p.Results.path;
    

    f1 = figure;
    ax = axes;
    plot(xline',u(:,1),'Parent',ax)
    
    ax.XLim = [ xline(1), xline(end) ];
    ax.XLabel.String = 'x';
    ax.YLabel.String = 'u(x)';
    
    ax.YLim = [ -2.5 +2.5 ];

    % plot u(:,t) to diferents times 
    tmax = tline(end);
    tic
    t = 0;

    if SaveGif
        gif([path,'wave.gif'],'DelayTime',0.1,'LoopCount',5,'frame',gcf)
    end
    
        
    while t <= tmax 
        if SaveGif   
            gif
        end
        t = xx*toc;
        [~ ,time_index] = min(abs(t - tline));
        delete(ax.Children)
        line(xline,u(:,time_index),'Parent',ax,'LineStyle','-','Marker','.')
        ax.Title.String = ['t = ',num2str(t,'%.2f'),' s'];

        pause(0.05)

        
        % if figure is closed, so stop execution
        if ~isvalid(ax)
            return
        end
    end
    
    
    
end
