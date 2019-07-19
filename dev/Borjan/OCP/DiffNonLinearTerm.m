function values = DiffNonLinearTerm(Y,alpha)
%NONLINEARTERM Summary of this function goes here
%   Detailed explanation goes here

%%
bi = (0<Y) .* (Y<alpha);
bi = logical(bi);
Fvalues = Y/(alpha);
values(bi) = Fvalues(bi);
%%
bi = Y>=alpha;
Fvalues = 0*Y + 1;
values(bi) = Fvalues(bi);
%%
bi = Y<=0;
Fvalues = Y*0;
values(bi) = Fvalues(bi);
%%
values = diag(values);
end

