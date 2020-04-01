function r = dotprod(iocp,X,Y)
%DOTPROD 

    tspan = iocp.DynamicSystem.tspan;
    Nt    = length(tspan);
    mesh  = iocp.DynamicSystem.mesh;
    Nx    = length(mesh);
    %
    L2prod = @(X,Y) trapz(mesh,arrayfun(@(ix) X(ix)'*Y(ix),1:Nx));
    %
    r = trapz(tspan,arrayfun(@(it)L2prod(X,Y),1:Nt));

end

