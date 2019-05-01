function Pnew = GetNumericalAdjoint(iCP,~,Ynew)
%GETNUMERICALADJOINT Summary of this function goes here
%   Detailed explanation goes here
    iCP.Adjoint.Dynamics.InitialCondition = iCP.kappa*(Ynew(end,:)' - iCP.Target) ;
    
    [~ , Pnew] = solve(iCP.Adjoint.Dynamics);
    Pnew = flipud(Pnew); 
        
end

