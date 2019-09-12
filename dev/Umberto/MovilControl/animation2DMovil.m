function animation2DMovil(idynamics)


    Nt = idynamics.Nt;
    meshx = idynamics.mesh{1};
    meshy = idynamics.mesh{2};

    dimx = length(meshx);
    dimy = length(meshy);

    State = idynamics.StateVector.Numeric;
    heatpart = State(:,1:end-2);
    movilpart = State(:,end-1:end);
    %%
    heatpart = reshape(heatpart,Nt,dimx,dimy);


    heatpart = reshape(heatpart,Nt,dimx,dimy);

    fig = figure('unit','norm','pos',[0 0 1 1],'Color',[0 0 0]);
    ax  = axes('Parent',fig);
    
    maxz = max(max(max(heatpart)));
    minz = min(min(min(heatpart)));

    
    %%
    [xms,yms] = meshgrid(meshx,meshy);
    
    meshx_fine = linspace(meshx(1),meshx(end),100);
    meshy_fine = linspace(meshy(1),meshy(end),100);
    
    [xms_fine,yms_fine] = meshgrid(meshx_fine,meshy_fine);

    Vfine = interp2(xms,yms,reshape(heatpart(1,:,:),dimx,dimy),xms_fine,yms_fine,'spline');

    %%
    
    isurf = surf(xms_fine,yms_fine,Vfine,'Parent',ax,'LineStyle','none');
    hold(ax,'on')

    %%
    x = movilpart(1,2);
    y = movilpart(1,1);
    radius = 0.1;
    % Create the mesh of shere
    [Xs,Ys,Zs] = sphere;
    X = Xs*radius + x; Y = Ys*radius + y; Z = 0.25*Zs*radius + 1.5*maxz;
    % create the sphere object
    jsurf = surf(X,Y,Z,'FaceLighting','gouraud','FaceColor','interp','LineStyle','none');
    colormap(ax,'jet')
    shading(ax,'interp')
%%
    
    ang = 25;
    view(ax,30,ang)
    ax.Color = 'none';
    isurf.FaceLighting = 'gouraud';
    lightangle(40,10)
    lightangle(-40,10)
    lightangle(-40,10)

    lightangle(0,0)

    zlim(ax,[minz 1.5*maxz+radius])
    daspect([1 1 1])
    axis(ax,'off')
    
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    zlim([-0.2 1])
    for it = 2:Nt
        
        Vfine = interp2(xms,yms,reshape(heatpart(it,:,:),dimx,dimy),xms_fine,yms_fine,'spline');

        isurf.ZData = Vfine;
        
        %%
        % change the sphere position
        %
        x = movilpart(it,2);
        y = movilpart(it,1);
    %
    	X = Xs*radius + x; Y = Ys*radius + y; Z = 0.25*Zs*radius + 1.5*maxz;

        jsurf.XData = X;
        jsurf.YData = Y;
        jsurf.ZData = Z;


        ang = ang - 0.05;
        view(ax,ang,30)

        pause(0.02)
    end

end