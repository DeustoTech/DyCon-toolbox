X = sym('x',[2 1]);
U = sym('u',[2 1]);

F = @(t,X,Y) [ -X(1) + U(2) ; ...
               -X(2) + U(1)];

idyn = dynamics(X,U,F);
idyn.InitCondition = [1 2];

Psi = @(t,X) X(2);
L   = @(t,X,U) U(1)^2 + U(2)^2;


Constraints = @(X) X - 1;
