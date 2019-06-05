function btn_reset_distribution(obj,event,h)
%BTN_RESET_DISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
h.surf_evolution.ZData = h.surf_evolution.ZData*0;
h.surf_estimation.ZData = h.surf_estimation.ZData*0;
h.InitialCondition = [];
h.Solution = [];
h.EstimationSolution = [];
delete(h.SourcePlot)
h.FinalCondition = [];
end

