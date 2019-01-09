function EingEvolution(autovalues,parameter_values,parameter_name,path) 

    f = figure;
    ax = axes('Parent',f);
    ax.XLabel.String = 'Real';
    ax.YLabel.String = 'Imaginary';
    ax.XGrid = 'on';ax.YGrid = 'on';
    ax.FontSize = 15;
    
    ax.XLim = [-1.5,0.5];
    ax.YLim = [-1.5,1.5];

    line([0 0], f.Children.YLim,'Color','k');  %y-axis
    line( f.Children.XLim, [0 0],'Color','k');  %x-axis
    
    gif(path,'DelayTime',0.1,'LoopCount',5,'frame',f)

    index = 0;
    for iautovalue = autovalues
        index = index + 1;

        preal  = real(iautovalue{:});
        pimag  = imag(iautovalue{:});
        %
        ax.Title.String = ['Eigenvalues Evolution of ',parameter_name,' = ',num2str(parameter_values(index),'%.2f')];

        %
        line(preal,pimag,'Marker','s','LineStyle','none')
        pause(0.1)
        gif

    end

end

