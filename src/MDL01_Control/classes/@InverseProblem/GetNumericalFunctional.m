function J = GetNumericalFunctional(iCP,Y)

    J = 0.5*trapz(iCP.dynamics.mesh, (iCP.FinalState - Y(end,:)).^2)   ...
        + iCP.gamma*trapz(iCP.dynamics.mesh,abs(Y(1,:))) ;

end

