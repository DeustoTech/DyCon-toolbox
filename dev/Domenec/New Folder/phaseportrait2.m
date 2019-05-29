%% scrip phase portrait

%define equations
tspan = linspace(0,2.5,200);
y0 = [0.1; 0];
y = ode113(@functionALLEE,tspan,y0);
Y5=y.y;
tspan = linspace(0,2.5,200);
y0 = [0.1; 0];
y = ode113(@functionALLEE2,tspan,y0);
Y6=y.y;

theta=0.2;
v=@(y)(Y6(2,end))/(Y6(1,end)-theta).*y-theta.*Y6(2,end)./(Y6(1,end)-theta);

tspan = linspace(0,5,200);
y0 = [0.12; v(0.12)];
y = ode113(@functionALLEE,tspan,y0);
Y7=y.y;
y0 = [0.14; v(0.14)];
y = ode113(@functionALLEE,tspan,y0);
Y8=y.y;
y0 = [0.16; v(0.16)];
y = ode113(@functionALLEE,tspan,y0);
Y9=y.y;

y0 = [0.18; v(0.18)];
y = ode113(@functionALLEE,tspan,y0);
Y10=y.y;



xspan=linspace(0.1,0.2,100);
recta=v(xspan);

figure(1)
plot(Y5(1,:),Y5(2,:),'k')
hold on
plot(Y6(1,:),Y6(2,:),'k')
hold on
plot(Y7(1,:),Y7(2,:),'k')
hold on
plot(Y8(1,:),Y8(2,:),'k')
hold on
plot(Y9(1,:),Y9(2,:),'k')
hold on
plot(Y10(1,:),Y10(2,:),'k')
hold on
plot(xspan,recta,'r')
xlim([0.05 0.25]);
ylim([-0.02 0.02])
grid on





tspan = linspace(0,40,100);
y0 = [0.01; -0.001];
y = ode45(@functionALLEE,tspan,y0);
Y=y.y;

y0 = [0; 0.01];
y = ode113(@functionALLEE,tspan,y0);
Y1=y.y;

y0 = [0.01; -0.000005];
y = ode113(@functionALLEE,tspan,y0);
Y2=y.y;
% 
y0 = [0.1; 0.01];
y = ode113(@functionALLEE,tspan,y0);
Y3=y.y;

tspan = linspace(0,40,2000);
y0 = [0.1; -0.00000000000000000001];
y = ode113(@functionALLEE,[0 40],y0);
Y4=y.y;



plot(Y(1,:),Y(2,:),'b')
hold on
plot(Y1(1,:),Y1(2,:),'b')
hold on
plot(Y2(1,:),Y2(2,:),'b')
hold on
plot(Y3(1,:),Y3(2,:),'b')
hold on
plot(Y4(1,:),Y4(2,:),'b')
hold on
plot(Y5(1,:),Y5(2,:),'b')
hold on
plot(Y6(1,:),Y6(2,:),'b')
hold on
xlim([0 0.4]);
ylim([-0.1 0.1])
