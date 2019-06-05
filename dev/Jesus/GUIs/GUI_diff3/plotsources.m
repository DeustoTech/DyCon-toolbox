function gh = plotsources(axes,Sources)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if ~isempty(Sources)
    gh(1) = line([Sources.x0],[Sources.y0],'Marker','.','LineStyle','none','MarkerSize',8,'Color','k','Parent',axes);
    gh(2) = line([Sources.x0],[Sources.y0],'Marker','o','LineStyle','none','MarkerSize',10,'Color','k','Parent',axes);
end
end

