function J = GetNumericalFunctional(iCP,Y,~)

    dims = arrayfun(@(i) length(i{:}),iCP.Dynamics.mesh);
    
    F = (iCP.FinalState - Y(end,:)).^2;
    
    switch length(dims) 
        case 1  % 1-D
            xline = iCP.Dynamics.mesh{1};
            J = 0.5*trapz(xline,F)   ...
                + 0.5*iCP.gamma*trapz(iCP.Dynamics.mesh,abs(Y(1,:)));
        case 2 % 2-D
            
            Fms             = reshape(      F      ,dims(1),dims(2));
            Regularization  = reshape( abs(Y(1,:)) ,dims(1),dims(2));
            
            xline = iCP.Dynamics.mesh{1};
            yline = iCP.Dynamics.mesh{2};
            
            J =   0.5* trapz(xline,trapz(yline,Fms,2))      ...
                + 0.5*iCP.gamma*trapz(xline,trapz(yline,Regularization,2)) ;           
    end
end

