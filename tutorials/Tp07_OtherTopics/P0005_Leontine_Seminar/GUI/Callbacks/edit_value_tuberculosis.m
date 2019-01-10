function edit_value_tuberculosis(object,event,h)
%EDIT_VALUE_TUBERCULOSIS Summary of this function goes here
%   Detailed explanation goes here
    listbox_layers = findobj_figure(h.figure,'Set Parameters','listbox');
    if strcmp(object.Tag,'name')
        h.tuberculosis_layers(listbox_layers.Value).(object.Tag) = object.String;
    else
        h.tuberculosis_layers(listbox_layers.Value).(object.Tag) = str2num(object.String);
    end
end

