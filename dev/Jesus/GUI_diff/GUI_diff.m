
clear
h = GUI_diff_handle;
h.figure = figure('Unit','norm','Position',[0.1 0.1 0.8 0.7],'Toolbar','none','MenuBar','none','NumberTitle','off','Name','Inverse Problem'); 

%% 
wd = 1.0;
ht = 0.2;
iGraph      = uipanel('Parent',h.figure,'Title','Graphs','Position', [0.0  ht     wd    1.0-ht]);
iControl    = uipanel('Parent',h.figure,'Position',[0 0 wd ht ]);


h.axes.InitialGraphs = subplot(1,3,1,'Parent',iGraph);
icg.Title.String = 'Initial Condition';

h.axes.EvolutionGraphs = subplot(1,3,2,'Parent',iGraph);
evg.Title.String = 'Evolution';

h.axes.EstimationGraphs = subplot(1,3,3,'Parent',iGraph);
esg.Title.String = 'Initial ConditionEstimation';

%%
generate_dynamics(h)
%%
btn_random = uicontrol('Parent',iControl,'String','Ramdon Sources','Unit','norm','Position',[0.1 0.1 0.1 0.4],'Callback',{@btn_random_callback,h});
btn_dyn    = uicontrol('Parent',iControl,'String','Solve Dynamics ','Unit','norm','Position',[0.3 0.1 0.1 0.4],'Callback',{@btn_solve_dyn_callback,h});
btn_gm    = uicontrol('Parent',iControl,'String','Gradient Method','Unit','norm','Position',[0.5 0.1 0.1 0.4],'Callback',{@btn_gm_callback,h});



