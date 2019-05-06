function plotsources(axes,Sources)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

line([Sources.x0],[Sources.y0],'Marker','.','LineStyle','none','MarkerSize',8,'Color','k','Parent',axes)
line([Sources.x0],[Sources.y0],'Marker','o','LineStyle','none','MarkerSize',10,'Color','k','Parent',axes)

end

