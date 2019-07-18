function values = DiffNonLinearTerm(Y,alpha)
%NONLINEARTERM Summary of this function goes here
%   Detailed explanation goes here
n = size(Y);
values = 0*Y;
%%
bi = Y>=alpha;
Fvalues = eye(n);
values(bi) = Fvalues(bi);
%%
bi = (0<Y) .* (Y<alpha);
bi = logical(bi);
Fvalues = diag(Y/(alpha));
values(bi) = Fvalues(bi);
end

