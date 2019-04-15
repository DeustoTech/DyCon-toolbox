function Pnew = GetNumericalAdjoint(iCP,Ynew)
%GETNUMERICALADJOINT Summary of this function goes here
%   Detailed explanation goes here
    iCP.adjoint.dynamics.InitialCondition = iCP.adjoint.FinalCondition(Ynew(end,:));
    [~ , Pnew] = solve(iCP.adjoint.dynamics);
    Pnew = flipud(Pnew); 
        
end

