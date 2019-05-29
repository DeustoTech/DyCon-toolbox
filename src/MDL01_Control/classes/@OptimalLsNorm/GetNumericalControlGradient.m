function dJ = GetNumericalControlGradient(iCP,~,U,P)
%GETNUMERICALINITGRADIENT Summary of this function goes here
%   Detailed explanation goes here
    xline = iCP.Dynamics.mesh;
    tspan = iCP.Dynamics.tspan;
    s     = iCP.s;
    B     = iCP.Dynamics.B;
    
    
    if s == Inf
        dJ = max(max(U))*sign(U) + P*B;
    else
        U_norm_Ls = trapz(tspan,trapz(xline,abs(U.').^s));
        U_norm_Ls = U_norm_Ls.^(1/s);
        U_norm_Ls = U_norm_Ls^(2-s);        
        dJ = U_norm_Ls*(U.*abs(U).^(s-2)) + P*B;
    end
    
    dJ = iCP.Dynamics.dt*dJ;
end

