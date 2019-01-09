function add_layer_tuberculosis(object,event,h)
%ADD_LAYER_TUBERCULOSIS Summary of this function goes here
%   Detailed explanation goes here
len = length(h.tuberculosis_layers);
h.tuberculosis_layers(len + 1) = tuberculosis_layer;
h.tuberculosis_layers(len + 1).name = ['layer_',num2str(length(h.tuberculosis_layers),'%.3d')];

update_tuberculosis_layer(h)
end

