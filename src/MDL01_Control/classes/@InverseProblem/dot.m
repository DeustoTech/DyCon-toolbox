function result = dot(iCP,X,Y)

    mesh = iCP.Dynamics.mesh;
    switch length(mesh)
        case 1 
            xline = mesh{1};
            result = trapz(X.*Y,xline);
        case 2
            xline = mesh{1};
            yline = mesh{2};
            Nx = length(xline);
            Ny = length(yline);


            result = trapz(xline,trapz(yline,reshape(X.*Y,Nx,Ny),2));

    end
    %
end