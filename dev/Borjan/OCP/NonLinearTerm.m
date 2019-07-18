function values = NonLinearTerm(Y,alpha)
%NONLINEARTERM Summary of this function goes here
%   Detailed explanation goes here

values = 0*Y;
%%
bi = (0<Y) .* (Y<alpha);
bi = logical(bi);
Fvalues = Y.^2/(2*alpha);
values(bi) = Fvalues(bi);
%%
bi = Y>=alpha;
Fvalues = Y-alpha/2;
values(bi) = Fvalues(bi);
%%
bi = Y<=0;
Fvalues = Y*0;
values(bi) = Fvalues(bi);
end

