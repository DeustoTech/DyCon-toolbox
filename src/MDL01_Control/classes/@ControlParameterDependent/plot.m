function  plot(iAverageProblem,varargin)
% description: The plot function applied to a ControlParameterDepent object shows 
%              three graphs that represent the evolution of the different dimensions 
%              of the state variable, the optimal control that leads the average state 
%              to the desired target, in addition to the convergence of the process.
% autor: JOroya
% MandatoryInputs:   
%   iAverageProblem: 
%    name: ControlParameterDependent object
%    description: Main object of ControlParameterDependent
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
%   U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tline)]
%    default:   empty

    p = inputParser;
    addRequired(p,'iAverageProblem')
    addOptional(p,'figure',[])
    addOptional(p,'XLim',[])
    addOptional(p,'ULim',[])
    addOptional(p,'JLim',[])

    
    parse(p,iAverageProblem,varargin{:})
       
    fig  = p.Results.figure;
    XLim = p.Results.XLim;
    ULim = p.Results.ULim;
    JLim = p.Results.JLim;
    

    %%
    solutions = iAverageProblem.addata.xhistory;
    uhistory  = iAverageProblem.addata.uhistory;
    Jhistory  = iAverageProblem.addata.Jhistory;
    if isempty(fig)
        fig = figure('Units','normalized');
        fig.Position(2) = 0.05;
        fig.Position(4) = fig.Position(4) + 0.15;
        set(fig,'defaultAxesFontSize',13)
        set(fig,'defaultAxesXGrid','on')
        set(fig,'defaultAxesYGrid','on')
    end
    
    %% Define axis 1  
    ax1  = subplot(3,1,1,'Parent',fig);
    
    ax1.XLabel.String = 't';
    ax1.YLabel.String = 'x_{i}(t)';
    ax1.Title.String = ['Evolution of mean vector state'];
    if ~isempty(XLim)
        ax1.YLim = XLim;
    end
    
        
    
    %% Define axis 2  
    ax2  = subplot(3,1,2,'Parent',fig);
    ax2.XLabel.String = 't';
    ax2.YLabel.String = 'u(t)';    
    if ~isempty(ULim)
        ax2.YLim = ULim;
    end
    %% Define axis 3
    ax3  = subplot(3,1,3,'Parent',fig);
    time_execution =  num2str(iAverageProblem.addata.time_execution,'%.3f');
    ax3.Title.String = ['Functional Convergence in ',time_execution,' s'];
    ax3.XLabel.String = 'iter';
    ax3.YLabel.String = 'J';    
    ax3.XLim = [0,length(Jhistory)];
    if ~isempty(JLim)
        ax3.YLim = JLim;
    end    
    
    %% plot in ax1, vector states 
    mt = solutions{end};
    lin1 = line(mt(:,1),mt(:,2:end),'Parent',ax1);
    %
    nvar = length(mt(1,2:end));
    legend(ax1,strcat(repmat('x_',nvar,1),num2str((1:nvar)')),'Location','NorthEastOutside')    %% plot in ax2, control 
    u = uhistory{end};
    lin2 = line(u(:,1),u(:,2),'Parent',ax2);
    %% plot in ax3, J functional 
    lin3 = line(1:length(Jhistory),Jhistory,'Parent',ax3,'Marker','o','LineStyle','-');
    
    
    
end

