function U = GetNumericalAdjoint2Control(iCP,P)
%GETSYMBOLICALADJOINT2CONTROL Summary of this function goes here
%   Detailed explanation goes here


tspan = iCP.Dynamics.tspan;

U = zeros(iCP.Dynamics.Nt,iCP.Dynamics.ControlDimension);


for it = 1:iCP.Dynamics.Nt
   U(it,:) = iCP.AnalyticalControl.Num(tspan(it),[],P(it,:));
end

end

