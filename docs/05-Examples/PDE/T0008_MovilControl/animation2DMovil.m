function animation2DMovil(fig,idynamics,State)


    Nt = idynamics.Nt;
    meshx = idynamics.xline;
    meshy = idynamics.yline;

    dimx = length(meshx);
    dimy = length(meshy);

    heatpart = State(:,1:end-4);
    movilpart = State(:,end-3:end-2);
    %%
    heatpart = reshape(heatpart,Nt,dimx,dimy);


    heatpart = reshape(heatpart,Nt,dimx,dimy);

    ax  = axes('Parent',fig,'unit','norm','pos',[0 0 1 1]);
    
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
    X = Xs*radius + x; Y = Ys*radius + y; Z = 0.25*Zs*radius + 0.5*maxz;
    % create the sphere object
    jsurf = surf(X,Y,Z,X*0+10,'FaceLighting','gouraud','FaceColor','interp','LineStyle','none');
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
    %daspect([1 1 1])
    axis(ax,'off')
    
    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);
    zlim([-0.5 0.5])
    caxis([-0.4 0.4])
    %
    
    for it = 2:Nt
        
        Vfine = interp2(xms,yms,reshape(heatpart(it,:,:),dimx,dimy),xms_fine,yms_fine,'spline');

        isurf.ZData = Vfine;
        
        %%
        % change the sphere position
        %
        x = movilpart(it,1);
        y = movilpart(it,2);
    %
    	X = Xs*radius + x; Y = Ys*radius + y; Z = 0.25*Zs*radius + 0.05*maxz;

        jsurf.XData = X;
        jsurf.YData = Y;
        jsurf.ZData = Z;


        ang = ang - 0.05;
        view(ax,ang,30)

        pause(0.075)
    end

end