function format_plot(fig)
%FORMAT_PLOT Summary of this function goes here
%   Detailed explanation goes here
    for ichild = fig.Children'
        if isa(ichild,'matlab.graphics.axis.Axes')
            set(ichild,'FontSize',14, 'FontName','Latin Modern Roman','XGrid','on','YGrid','on','color',[1,1,1])
            
        end
        if isa(ichild,'matlab.graphics.illustration.Legend')
            set(ichild,'FontSize',14, 'FontName','Latin Modern Roman')
        end
    end
end

