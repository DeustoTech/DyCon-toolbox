function prueba11
T  = 1;

Nt = 10;
Nx = 10;
xline = linspace(-1,1,Nx);
tspan =  linspace(0,T,Nt);

YT = zeros(Nx,1);

Y0 = zeros(Nt,Nx);
U0 = ones(Nt,Nx);

YU0 = [Y0,U0];

functional(YU0)


function J = functional(YU)
    
    Y = YU(:,1:Nx);
    U = YU(:,Nx+1:end);

    J = trapz(xline',(YT - Y(end,:)').^2) + trapz(xline,trapz(tspan,U.^2,2)) ;

end


    function [C,Ceq] = constraints(YU)
        
        Y = YU(:,1:Nx);
        U = YU(:,Nx+1:end);
        
        C = (I+dt*A)
        
    end

end