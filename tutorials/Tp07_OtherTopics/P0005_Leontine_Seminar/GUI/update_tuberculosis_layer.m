function update_tuberculosis_layer(h)
%UPDATE_TUBERCULOSIS_LAYER Summary of this function goes here
%   Detailed explanation goes here

    listbox_layers = findobj_figure(h.figure,'Set Parameters','listbox');
    listbox_layers.String = {h.tuberculosis_layers.name};

    tl = h.tuberculosis_layers(listbox_layers.Value);
    
    
    for label = [h.label_parameters h.label_initial]
        edit = findobj_figure(h.figure,label{:});
        edit.String = num2str(tl.(label{:}));
    end
    
    edit = findobj_figure(h.figure,'name');
    edit.String = tl.name;

end

