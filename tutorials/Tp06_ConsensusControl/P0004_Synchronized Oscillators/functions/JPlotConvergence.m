function f1 = JPlotConvergence(results,title)
% ======================================================================
%  Convergencia del Funcional  
% ======================================================================
%%
t           = results.t;
Jhistory    = results.Jhistory;
%%
f1 = figure; ax1 = axes;
plot(1:length(Jhistory),Jhistory,'Parent',ax1,'Marker','s')
ax1.FontSize = 13;
ax1.Title.String = [ 'J Functional ',title,'  ||  t = ',num2str(t),' s'];
ax1.XLabel.String = 'Iterations';ax1.YLabel.String = 'J(\theta,u)';
grid on

end

