function animation(iode,varargin)
% description: Metodo de Es
% autor: JOroya
% MandatoryInputs:   
% iCP: 
%    name: Control Problem
%    description: 
%    class: ControlProblem
%    dimension: [1x1]
% OptionalInputs:
% U0:
%    name: Initial Control 
%    description: matrix 
%    class: double
%    dimension: [length(iCP.tspan)]
%    default:   empty
    p = inputParser;
    
    addRequired(p,'iode')
    addOptional(p,'YLim',[])
    addOptional(p,'xx',1.0)
    
    parse(p,iode,varargin{:})
    
    YLim = p.Results.YLim;
    xx = p.Results.xx;

    structure = [iode.VectorState];
    Y = {structure.Numeric};
        
    f = figure;
    ax = axes('Parent',f);
    if ~isempty(YLim)
        ax.YLim = YLim;
    end
    
    %
    tspan = iode.tspan;
        
    tic;
    tmax = tspan(end);
    
    [nrow ncol] = size(Y{1});
    
    
    while true 
        t = xx*toc;
        if t > tmax
            break
        end
        if exist('l','var')
            delete(l)
        end
        ax.Title.String = ['t = ',num2str(t,'%.2f')];
        
        index = 0;
        colors = {'r','g','b'};
        LinS = {'-','--'};
        pt = {'*','s'};
        for iY = Y
            ic = mod(index,3) + 1;
            il = mod(index,2) + 1;
            ip = mod(index,2) + 1;
            index = index + 1;
            l(index) = line(1:ncol,interp1(tspan,iY{:},t),'Parent',ax,'Marker',pt{ip},'LineStyle',LinS{il},'Color',colors{ic});
        end
        legend({iode.label})
        pause(0.1)
    end

end

