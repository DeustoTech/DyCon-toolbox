function f2 = ThetaAnimation(Results,varargin)
%THETAANIMATION Summary of this function goes here
%   Detailed explanation goes here
% ======================================================================
    %
    p = inputParser;
    
    addRequired(p,'Results')
    addOptional(p,'XLim',[]);    
    addOptional(p,'YLim',[]);    

    parse(p,Results,varargin{:})
    
    
    XLim = p.Results.XLim;
    YLim = p.Results.YLim;
    
    Thetahistory = Results.Thetahistory;
    tspan        = Results.tspan;
    
    %
    f2 = figure;
    ax2 = axes;
    
    if ~isempty(XLim)
        ax2.XLim = XLim;
    end
    
    if ~isempty(YLim)
        ax2.YLim = YLim;
    end
    
    %
    ax2.XGrid = 'on';
    ax2.YGrid = 'on';
    %
    ax2.YLabel.String = '\theta_i(t)';
    ax2.XLabel.String = 't(s)';
    ax2.FontSize = 15;
    
    N = length(Thetahistory(:,1,1));
    iter = length(Thetahistory(1,1,:));
    
    for i = 1:iter-1

        for dim = 1:N
            line(tspan',Thetahistory(dim,:,i),'Parent',ax2)
        end
        
        ax2.Title.String = ['\theta_i(t) Evolution in iter = ',num2str(i)];

        pause(0.75)
        if i~=(iter-1)
            delete(ax2.Children)
        end
    end
end

