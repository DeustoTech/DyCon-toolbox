function tuberculosis_model
%TUBERCULOSIS_MODEL Summary of this function goes here
%   Detailed explanation goes here

h = tuberculosis_GUI;

h.figure = figure('Name','Tuberculosis Model',  ...
                      'NumberTitle','off',       ...
                      'Units', 'normalize',      ...
                      'Position', [0.005 0.05 0.945 0.85],     ...
                      'Visible','on',           ...
                      'MenuBar','none');
%%
tabgp = uitabgroup(h.figure,                            ...
                   'Units','normalize',                 ...
                   'Position',[0.005 0.01 0.99 0.98],   ...
                   'Tag','tabgroup',                    ...
                   'SelectionChangedFcn',{@SelectionChangedFcn_tuberculosis,h});

%%
set_parameters   = uitab(tabgp,'Title','Set Parameters','Tag','Set Parameters');

wdp = 0.7;
wdi = 0.15;

hrun = 0.4;
%% Diagram
diagram_panel = uipanel('Parent',set_parameters,'Units','normalized','Position',[0.0  0.0  wdp       1.0],'Title','Diagram');
axes_diagram  = axes('Parent',diagram_panel,'Unit','normalized','Position',[0 0 1 1]);

[image_map,~] = imread('GUI/imgs/diagram.png');
image_map = imresize(image_map, 2);

image(axes_diagram.XLim, axes_diagram.YLim,image_map)
axes_diagram.XTick = [];
axes_diagram.YTick = [];
%% Parameters 
parameters_panel = uipanel('Parent',set_parameters,'Units','normalized','Position',[wdp  0.0  1.0-wdp-wdi  1.0],'Title','Parameters');
axes_parameters = axes('Parent',parameters_panel,'Units','normalize','Position',[0.0 0.0 0.5 1.0]);
axes_parameters.XTick = [];
axes_parameters.YTick = [];
axes_parameters.Color = [ 0.94 0.94 0.94];
%
vars = h.latex_parameters;
label = h.label_parameters;
width = 1/(length(vars)+1);
for index = 1:length(vars)
    ynorm = index*width;
    text(0.4,1.0-ynorm,vars{index},'FontSize',20,'Parent',axes_parameters)
    edit_pi1 = uicontrol('style','edit','Parent',parameters_panel,'Units','normalize','Position',[0.5 1-ynorm-0.025 0.2 0.04],'String','0','Tag',label{index},'Callback',{@edit_value_tuberculosis,h});
end
%% Initial Conditions
initial_panel = uipanel('Parent',set_parameters,'Units','normalized','Position',[1.0 - wdi   hrun  wdi  1-hrun],'Title','Initial Conditions');
axes_initial = axes('Parent',initial_panel,'Units','normalize','Position',[0.0 0.0 0.5 1.0]);
axes_initial.XTick = [];
axes_initial.YTick = [];
axes_initial.Color = [ 0.94 0.94 0.94];
% 
vars = h.latex_initial;
label = h.label_initial;

%h.initial_conditions = vars;
width = 1/(length(vars)+1);
for index = 1:length(vars)
    ynorm = index*width;
    text(0.4,1.0-ynorm,vars{index},'FontSize',20,'Parent',axes_initial)
    edit_pi1 = uicontrol('style','edit','Parent',initial_panel,'Units','normalize','Position',[0.5 1-ynorm-0.025 0.2 0.08],'String','0','Tag',label{index},'Callback',{@edit_value_tuberculosis,h});
end
%% Run
run_panel = uipanel('Parent',set_parameters,'Units','normalized','Position',[1.0 - wdi   0.0  wdi  hrun],'Title','Layers');
    
    %%
    text_name = uicontrol('Parent',run_panel,'Style','text','Units','normalized','Position',[0.1 0.8 0.4 0.1],'String','name','FontSize',12);
    edit_name = uicontrol('Parent',run_panel,'Style','edit','Units','normalized','Position',[0.5 0.8 0.4 0.1],'Tag','name','FontSize',12,'Callback',{@edit_value_tuberculosis,h});
    %%
    listbox = uicontrol('Parent',run_panel,'Units','normalized','Position',[0.1 0.35 0.65 0.4],'style','listbox','Tag','listbox','String','layer_001','Callback',{@listbox_tuberculosis_callback,h},'FontSize',14);
    add_btn     = uicontrol('Parent',run_panel,'String','+','Units','normalized','Position',[0.775 0.55 0.15 0.15],'FontSize',14,'Callback',{@add_layer_tuberculosis,h});
    minus_btn   = uicontrol('Parent',run_panel,'String','-','Units','normalized','Position',[0.775 0.4 0.15 0.15],'FontSize',14,'Callback',{@minus_layer_tuberculosis,h});
    btn_run = uicontrol('Parent',run_panel,'Units','normalized','Position',[0.25 0.1 0.5 0.2],'String','Run!','FontSize',14,'Callback',{@run_btn_tuberculosis,h});
%% Graphs
Graphical_representation   = uitab(tabgp,'Title','Graphs','Tag','Graphs');
axes('Parent',Graphical_representation,'Tag','axes')

update_tuberculosis_layer(h)
end

