function out = plot_target_sd(ax,file)
%PLOT_TARGET_SD Summary of this function goes here
%   Detailed explanation goes here

switch file(8)
    case '1'
        Target = [5 0];

    case '2'
        Target = [4 4];

    case '3'
        Target = [0 0];

end

out = line(Target(1),Target(2),'Marker','s','Parent',ax,'MarkerSize',20,'Color','k','LineStyle','none');
end

