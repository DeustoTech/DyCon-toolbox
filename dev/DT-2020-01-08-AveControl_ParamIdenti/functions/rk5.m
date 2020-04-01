function [tspan,X] = rk5(func, tspan, x0)


Nt = length(tspan);
N = length(x0);

X = zeros(Nt,N);

X(1,:) = x0;
for k=2:Nt % loop over control intervals
    h = tspan(k) - tspan(k-1);
    t = tspan(k-1);
    y_0 = X(k-1,:);
    F1 = func(t        , y_0'          );
    F2 = func(t+h/4    , y_0'+(h/4)*F1);
    F3 = func(t+h/4    , y_0'+(h/8)*F1+(h/8)*F2);
    F4 = func(t+h/2    , y_0'-(h/2)*F2+h*F3);
    F5 = func(t+(h*3/4), y_0'+(h*3/16)*F1+(h*9/16)*F4);
    F6 = func(t+h      , y_0'-(h*3/7)*F1+(h*2/7)*F2+(h*12/7)*F3-(h*12/7)*F4+(h*8/7)*F5);
    X(k,:) = X(k-1,:) + (h/90)*(7*F1+32*F3+12*F4+32*F5+7*F6)';

end