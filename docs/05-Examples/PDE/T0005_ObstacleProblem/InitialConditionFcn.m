function Y0 = InitialConditionFcn(xline)
%INITIALCONDITIONFCN Summary of this function goes here
%   Detailed explanation goes here
Y0 = 0*xline';
%%
bi = xline<=-3/2;
Fvalues = -2*0.8*xline' - 3*0.8;
Y0(bi) = Fvalues(bi);
%%
bi = xline>= 3/2;
bi = logical(bi);
Fvalues = +2*0.8*xline' - 3*0.8;
Y0(bi) = Fvalues(bi);
end

