Y = sym('y',[2 1]); U = sym('u',[2 1]);
% define your wierd dynamics
F = [ sin(Y(1)*Y(2)) + cos(Y(1)*Y(2)) + U(1); ...
      sin(Y(1)*Y(2)) + cos(Y(1)*Y(2)) + U(2) ] ;
dynamics = ode(F,Y,U);
dynamics.Type = 'FinalCondition';

solve(dynamics)
plot(dynamics)

dynamics.Type = 'InitialCondition';
solve(dynamics,'RungeKuttaMethod',@ode23)
plot(dynamics)


A = [ -1 0 ; 0 -1];
B = [1 ; 1];

ode('A',A,'B',B)