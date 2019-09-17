function animation2D(idynamics)
    State = idynamics.StateVector.Numeric;
    meshx = idynamics.mesh{1};
    meshy = idynamics.mesh{2};

    dimx = length(meshx);
    dimy = length(meshy);

    Nt = idynamics.Nt;
    State = reshape(State,Nt,dimx,dimy);

    fig = figure;
    ax  = axes('Parent',fig);
    
    maxz = max(max(max(State)));
    minz = min(min(min(State)));

    
    isurf = surf(reshape(State(1,:,:),dimx,dimy),'Parent',ax);
    zlim(ax,[minz maxz])

    for it = 2:Nt
        isurf.ZData = reshape(State(it,:,:),dimx,dimy);
        pause(0.1)
    end
end