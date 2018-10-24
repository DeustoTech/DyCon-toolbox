function ric = f_ricc_d(X, A, R, Q)

% solve dX/dt = XA + A'X - XRX + Q

X = reshape(X, size(A)); %Convert from "n^2"-by-1 to "n"-by-"n"
dXdt = A.' * X + X * A - X * R * X + Q; %Determine derivative
ric = dXdt(:); %Convert from "n"-by-"n" to "n^2"-by-1