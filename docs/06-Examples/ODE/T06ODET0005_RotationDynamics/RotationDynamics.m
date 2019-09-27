clear
Y = sym('y',[2 1]);
U = sym('u',[1]);

theta = pi;
R = [ cos(theta) sin(theta); ...
     -sin(theta) cos(theta)];
%
dt = 0.1250;

A = (R-eye(2))/dt;
F = @(t,Y,U,Params) A*Y;

idynamics = ode(F,Y,U);
idynamics.InitialCondition = [1 1]';
idynamics.FinalTime = 50;
idynamics.Nt = 400;
[~ ,Y] = solve(idynamics);


animation(Y)
function animation(Y)
    figure;
    [Nt,Nvar] = size(Y);
    l1 = line([0 Y(1,1)],[0 Y(1,2)],'Marker','*');
    xlim(l1.Parent,[-2 2]);
    ylim(l1.Parent,[-2 2]);
    for it = 1:Nt
        l1.XData(2) = Y(it,1);
        l1.YData(2) = Y(it,2);
        pause(0.01)
    end
end