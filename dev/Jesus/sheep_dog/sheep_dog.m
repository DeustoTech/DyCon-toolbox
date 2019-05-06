close all

h = sheep_dog_class;
h.figure = figure('Unit','norm','Position',[0.05 0.05 0.9 0.9],'Toolbar','none','MenuBar','none','NumberTitle','off','Name','Sheep vs Dogs'); 

set(h.figure,'DefaultuipanelFontSize',14)
set(h.figure,'DefaultuicontrolFontSize',14)

panel_graphs = uipanel('unit','norm','pos',[0.0 0.0 0.85 1.0],'Parent',h.figure);

h.ax = axes('Parent',panel_graphs,'unit','norm','pos',[0 0 1 1]);
axis(h.ax,'off');

panel_options = uipanel('unit','norm','pos',[0.85 0.0 0.15 1.0],'Parent',h.figure);

cases = {'Case 1','Case 2','Case 3'};
%%
panel_dogs   = uipanel('Parent',panel_options,'unit','norm','pos',[0.00 0.7 1.0 0.3],'Title','Dogs Distribution');
h.listbox_dogs = uicontrol('Parent',panel_dogs,'style','listbox','unit','norm','pos',[0.1 0.1 0.8 0.8]);
h.listbox_dogs.String = cases;
h.listbox_dogs.Callback = {@callback_listbox,h};

panel_sheep  = uipanel('Parent',panel_options,'unit','norm','pos',[0.00 0.4 1.0 0.3],'Title','Sheeps Distribution');
h.listbox_sheep = uicontrol('Parent',panel_sheep,'style','listbox','unit','norm','pos',[0.1 0.1 0.8 0.8]);
h.listbox_sheep.String = cases;
h.listbox_sheep.Callback = {@callback_listbox,h};


panel_target = uipanel('Parent',panel_options,'unit','norm','pos',[0.00 0.1 1.0 0.3],'Title','Targets');
h.listbox_target = uicontrol('Parent',panel_target,'style','listbox','unit','norm','pos',[0.1 0.1 0.8 0.8]);
h.listbox_target.String = cases;
h.listbox_target.Callback = {@callback_listbox,h};


panel_compu  = uipanel('Parent',panel_options,'unit','norm','pos',[0.0  0.0  1.0 0.1]);
go_btn = uicontrol('Parent',panel_compu,'unit','norm','pos',[0.2 0.25 0.6 0.5],'String','Compute!','Callback',{@callback_animation_sheep_dog,h});

%% init 
see_init_sheep_dogs(h.ax,'example111.mat')
