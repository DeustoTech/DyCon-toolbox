N = 10;

a = linspace(6,14,N);
%a = 8;
%b = linspace(25,27,N);
b = 28
c = 8/3;

Color = parula(N);

fig = figure('Color','none');
ax  = axes('Parent',fig,'Color','none','unit','norm','pos',[0 0 1 1]);
axis(ax,'off')
view(49,-5)
for iter = 1:N
    Y = abc2Ysolution(a(iter),b,c);
    line(Y(:,1),Y(:,2),Y(:,3),'Marker','none','Color',Color(iter,:))
    line(Y(end,1),Y(end,2),Y(end,3),'Marker','.','Color','k','MarkerSize',20)

end
line(0.1,0.1,0.1,'Marker','.','Color','r','MarkerSize',20)
%%
view(45,45)

saveas(fig,'Barchart.png')




function Y = abc2Ysolution(a,b,c)

Fcn = @(t,Y,U,Params) [ a*(Y(2)-Y(1)); ...
                        Y(1)*(b-Y(3)) - Y(2); ...
                        Y(1)*Y(2) - c*Y(3) ];
                    
syms x y z u;
Y = [x y z];
U = u;
idynamics = ode(Fcn,Y,U);
%%
idynamics.InitialCondition = [0.1 0.1 0.1]';
idynamics.FinalTime = 6;
idynamics.Nt = 1000;
[~, Y ] = solve(idynamics);
end