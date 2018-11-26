function animation(iode,varargin)
%ANIMATION Summary of this function goes here
%   Detailed explanation goes here
    p = inputParser;
    
    addRequired(p,'iode')
    addOptional(p,'YLim',[])
    addOptional(p,'xx',1.0)
    
    parse(p,iode,varargin{:})
    
    YLim = p.Results.YLim;
    xx = p.Results.xx;

    Y = iode.Y;
    
    
    f = figure;
    ax = axes('Parent',f);
    if ~isempty(YLim)
        ax.YLim = YLim;
    end
    
    %
    tline = iode.tline;
        
    tic;
    tmax = tline(end);
    
    [nrow ncol] = size(Y);
    while true 
        t = xx*toc;
        if t > tmax
            break
        end
        if exist('l','var')
            delete(l)
        end
        l = line(1:ncol,interp1(tline,Y,t),'Parent',ax,'Marker','*','LineStyle','-');
        pause(0.1)
    end

end

