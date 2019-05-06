function callback_animation_sheep_dog(obj,event,h)
%CALLBACK_ANIMATION_SHEEP_DOG Summary of this function goes here
%   Detailed explanation goes here
dogs   = h.listbox_dogs.String{h.listbox_dogs.Value};
dogs = strsplit(dogs,' ');
dogs = dogs{2};

%%
sheep   = h.listbox_sheep.String{h.listbox_sheep.Value};
sheep = strsplit(sheep,' ');
sheep = sheep{2};

%%

target   = h.listbox_target.String{h.listbox_target.Value};
target = strsplit(target,' ');
target = target{2};


%%
file = ['example',target,sheep,dogs,'.mat'];

delete(h.ax.Children)
ani_sheep_dogs(h.ax,file)
end

