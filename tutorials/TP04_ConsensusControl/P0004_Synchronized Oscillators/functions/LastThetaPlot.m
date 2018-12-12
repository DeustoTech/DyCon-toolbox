function fig = LastThetaPlot(Result)
%THETAPLOTCONVERGENCE Summary of this function goes here
%   Detailed explanation goes here
    fig = figure;
    ax = axes('Parent',fig);
    
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    
    ax.FontSize = 13;

    ax.Title.String = 'Evolution of Oscilators';

    ax.XLabel.String = 'time(s)';
    ax.YLabel.String = '\theta_i(t)';
    
    mt = Result.Thetahistory(:,:,end)';
    tspan = Result.tspan;
    
    line(tspan,mt)

    
end

