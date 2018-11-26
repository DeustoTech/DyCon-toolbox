function PDEControlEvolution(iCP1,varargin)
%PDECONTROLEVOLUTION Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    
    addRequired(p,'iCP1')
    addOptional(p,'YLim',[])
    
    parse(p,iCP1,varargin{:})
    
    YLim = p.Results.YLim;
    
    yend = iCP1.yhistory{end};
    
    
    f = figure;
    ax = axes('Parent',f);
    if ~isempty(YLim)
        ax.YLim = YLim;
    end
    
    %
    tline = iCP1.ode.tline;
    
    index = 0;
    for irow = 1:length(yend(:,1))
        index = index + 1;
        delete(ax.Children)
        line(1:length(yend(irow,:)),yend(irow,:),'Parent',ax,'Marker','*')
        ax.Title.String = ['t = ',num2str(tline(index)),' s'];
        pause(0.1)
    end
end

