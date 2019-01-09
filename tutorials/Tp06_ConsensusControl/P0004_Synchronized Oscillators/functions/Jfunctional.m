function Jis = Jfunctional(u,tspan,thetaT,beta)
    N = length(thetaT);
    Jis = zeros(length(thetaT),1);
    index = 0;
    for ithetaT = thetaT'
        index = index + 1;
        sum = 0;
        for jthetaT = thetaT'
            sum = sum + (jthetaT-ithetaT).^2;
        end
        Jis(index) = (0.5/N)*sum + 0.5*beta*trapz(tspan,u(:,index).^2);
    end
end
