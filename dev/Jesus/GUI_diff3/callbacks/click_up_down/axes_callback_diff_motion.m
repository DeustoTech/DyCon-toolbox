function axes_callback_diff_motion(obj,eve,h)
%BTN_SOLVE_DYN_CALLBACK Summary of this function goes here
%   Detailed explanation goes here

if ~h.click
    return
end
xms = h.grid.xms;
yms = h.grid.yms;

h.click = true;
k = 0.3;
alpha = 0.2;


CP = h.axes.EvolutionGraphs.CurrentPoint(1,1:2);
x0 = CP(1);y0 = CP(2);
h.surf_evolution.ZData   = h.surf_evolution.ZData + k*exp(-((xms-x0).^2  + (yms-y0).^2)/alpha^2);


h.FinalCondition = reshape(h.surf_evolution.ZData,h.N*h.N,1);
