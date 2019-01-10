function SelectionChangedFcn_tuberculosis(object,event,h)
%SELECTIONCHANGEDFCN_TUBERCULOSIS Summary of this function goes here
%   Detailed explanation goes here
    if ~strcmp(object.SelectedTab.Title,'Graphs')
        return
    end
    

    panel = findobj_figure(h.figure,'Graphs');

    delete(panel.Children)
    Colors = {'r','g','b','k','c','y'};
    
    index = 0;
    
    labels = {};
    for tl = h.tuberculosis_layers
        index = index + 1;
        labels{index} = tl.name;
    end
    
    FontSize = 14;
    
    ax = subplot(3,2,1,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'S - Susceptible';
    index_col = 2;
    plot_value(ax,XLabel,YLabel,index_col)
    
    %%
    ax = subplot(3,2,2,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'V - vaccinated';
    index_col = 3;
    plot_value(ax,XLabel,YLabel,index_col)
    %%
    ax = subplot(3,2,3,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'Aids patients';
    index_col = 3;
    plot_value(ax,XLabel,YLabel,index_col)   
    %%
    ax = subplot(3,2,4,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'Earlier Latents';
    index_col = 5;
    plot_value(ax,XLabel,YLabel,index_col)   
    %%
    ax = subplot(3,2,5,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'Vaccine coverage';
    index_col = 6;
    plot_value(ax,XLabel,YLabel,index_col)   
    %%
    ax = subplot(3,2,6,'Parent',panel,'FontSize',FontSize);
    XLabel = 'Time';
    YLabel = 'TB infectious';
    index_col = 6;
    plot_value(ax,XLabel,YLabel,index_col)       
    
    return



    function plot_value(ax,XLabel,YLabel,index_col)
        ax.XLabel.String = XLabel;
        ax.YLabel.String = YLabel;
        index_bucle = 0;
        for tl = h.tuberculosis_layers
            if ~isempty(tl.result)
                index_bucle = index_bucle + 1;
                idc = index_bucle - floor(index_bucle/length(Colors));
                line(tl.result(1,:),tl.result(index_col,:),'Parent',ax,'Color',Colors{idc});
            end
        end

        legend(labels)
    end
end


