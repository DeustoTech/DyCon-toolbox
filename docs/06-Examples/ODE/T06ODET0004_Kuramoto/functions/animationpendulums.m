
function animationpendulums(ThetaEvolutions,tspan,labels)
%% Parameters
    radius = 1.0;
    separation = 4;
    LineWidth = 2;
    el = 5;
    az = 8;
    frecuency =3;
    %%
n = length(ThetaEvolutions);
fig = figure('unit','norm','pos',[0 0 1 1]);

fig.Color = [0 0 0];
for i = 1:n
    %%
    ThetaEvolution = ThetaEvolutions{i};
    [~ ,Nspheres] = size(ThetaEvolution);

    long  = 10;
    %%
    ax{i}  = axes('Parent',fig,'unit','norm','pos',[(i-1)/n + 0.1/n 0 0.8/n 1]);

    ax{i}.Color = [0 0 0];
    view(6,23)
    daspect([1 1 1])
    ax{i}.XAxis.Color = [1 1 1];
    ax{i}.YAxis.Color = [1 1 1];
    ax{i}.ZAxis.Color = [1 1 1];
    %%
    lightangle(-45,45)
    lightangle(-163,-45)

    %%
    hold(ax{i},'on')


    %%
    ax{i}.YLim = [0,separation*(Nspheres+1)];
    ax{i}.XLim = [-0.5*separation*(Nspheres+1),0.5*separation*(Nspheres+1)];
    ax{i}.ZLim = [- 4*radius 2*long + 2*radius];
    ax{i}.XTick = [];
    ax{i}.YTick = [];
    ax{i}.ZTick = [];
    annotation('textbox','Pos',[1/(2*n) + (i-1)/n - 0.05 0.8 0.1 0.1],'String',labels{i},'Color','white','FontSize',18)
    box(ax{i})
    %%
    [Xs,Ys,Zs] = sphere;

    y = 0;
    for iter = 1:Nspheres
        x = 0; z = 0;
        y = y + separation;
        X = (Xs+x)*radius; Y = (Ys+y)*radius; Z = (Zs+z)*radius;

        lines(iter)   = line([x x],[y y],[z z+long],'LineWidth',LineWidth,'Parent',ax{i},'Color','white');
        spheres(iter) = surf(X,Y,Z,'FaceLighting','gouraud','LineStyle','none','FaceColor','interp','Parent',ax{i});
        spheres(iter).CData = spheres(iter).CData*0;
    end
    linesax{i}   = lines;
    spheresax{i} = spheres;
    
    line([lines(1).XData(2) lines(end).XData(2)], ...
         [lines(1).YData(2) lines(end).YData(2)], ...
         [lines(1).ZData(2) lines(end).ZData(2)],'Color',[0.4 0.4 0.4],'LineWidth',2*LineWidth,'Parent',ax{i})

end
 %%
[nrow,ncol] = size(ThetaEvolution);

% % gif('animation.% gif','frame',fig)
%%
for i = 1:n
    ThetaEvolution = ThetaEvolutions{i};
    lines = linesax{i};
    spheres = spheresax{i};
    irow = 1;
    for icol = 1:ncol
        %
        angle = frecuency*pi*tspan(irow) + ThetaEvolution(irow,icol);
        %
        x = 0.4*long*sin(angle);
        %z = long*(-cos(angle) + 1);
        z = long - sqrt(long^2 - x^2);
        X = (Xs+x)*radius;
        Z = (Zs+z)*radius;
        %
        spheres(icol).XData = X;
        spheres(icol).ZData = Z;
        %
        lines(icol).XData(1) = x;
        lines(icol).ZData(1) = z;
    end
    %
    spheres(icol).XData = X;
    spheres(icol).ZData = Z;
    %
    lines(icol).XData(1) = x;
    lines(icol).ZData(1) = z;
end
%%
for iter = 1:50
    for i = 1:n

    Azz = az + 180*iter/50;
    view(ax{i},Azz,el)
    end
    % gif('frame',fig)
    pause(0.05)    

end
az = Azz;
%%
for iter = 1:20
    %pause(0.01)    
    % gif('frame',fig)
    pause(0.01)   
end
%%
%%
for irow = 2:3:nrow
    for i = 1:n
    ThetaEvolution = ThetaEvolutions{i};
    lines = linesax{i};
    spheres = spheresax{i};
    for icol = 1:ncol
        angle = frecuency*pi*tspan(irow) + ThetaEvolution(irow,icol);
        %
        x = 0.4*long*sin(angle);
        %z = long*(-cos(angle) + 1);
        z = long - sqrt(long^2 - x^2);
        %
        X = (Xs+x)*radius;
        Z = (Zs+z)*radius;
        %
        spheres(icol).XData = X;
        spheres(icol).ZData = Z;
        %
        lines(icol).XData(1) = x;
        lines(icol).ZData(1) = z;

    end

%         el = el + 0.01;
%         az = az - 0.01;
%         view(ax{i},az,el)

    end

    pause(0.02)
    % gif('frame',fig)
end