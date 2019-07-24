function f = fsource(location,state)

x = location.x;
y = location.y;



height = 1e5;
hardness   = 30;

wall = exp((-x.^2 - y.^2)/0.15^2);


f = + (height/2) + (height/2)*tanh(hardness.*(- state.u + wall))  - 20;