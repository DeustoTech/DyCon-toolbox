function [dynamics,mesh] = DynamicsInvProblem

    dynamics = createpde(1);
    g = GeoInvProblem;

    geometryFromEdges(dynamics,g);


    %applyBoundaryCondition(dynamics,'Edge',(1:4),'r',@bcd);
    mesh = generateMesh(dynamics,'Hmax',1);

    %applyBoundaryCondition(dynamics,'dirichlet','Face',all_points,'r',@bcd);
    applyBoundaryCondition(dynamics,'dirichlet','Edge',1:4);


    %% Init Condition

    gauss = @(max,sigma,x,y) max*exp(-(x.^2 + y.^2).^2/sigma.^2 );

    u0fun =  @(location) gauss(-1   , 0.1 ,location.x + 0   ,location.y +1   ) 

    setInitialConditions(dynamics,u0fun)
    

end