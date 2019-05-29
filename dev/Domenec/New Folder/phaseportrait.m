%% scrip phase portrait

%define equations
tspan = linspace(0,0.3,200);
y0 = [0.1; 0];
y = ode113(@functionALLEE,tspan,y0);
Y5=y.y;
tspan = linspace(0,0.3,200);
y0 = [0.1; 0];
y = ode113(@functionALLEE2,tspan,y0);
Y6=y.y;

theta=0.2;
v=@(y)(Y6(2,end))/(Y6(1,end)-theta).*y-theta.*Y6(2,end)./(Y6(1,end)-theta);

tspan = linspace(0,0.6,200);
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





tspan = linspace(0,35,200);
y0 = [0.01; -0.001];
[~ , Y] = ode45(@functionALLEE,tspan,y0);

y0 = [0; 0.01];
[~ , Y1] = ode45(@functionALLEE,tspan,y0);

y0 = [0.01; -0.000005];
[~ , Y2] = ode45(@functionALLEE,tspan,y0);
% 
y0 = [0.1; 0.01];
[~ , Y3] = ode45(@functionALLEE,tspan,y0);

tspan = linspace(0,40,200);
y0 = [0.1; -0.00000000000000000001];
[~ , Y4] = ode45(@functionALLEE,tspan,y0);


Y = Y';
Y1 = Y1';
Y2 = Y2';
Y3 = Y3';
Y4 = Y4';


plot(Y(1,:),Y(2,:),'b')
hold on
plot(Y1(1,:),Y1(2,:),'b')
hold on
plot(Y2(1,:),Y2(2,:),'b')
hold on
plot(Y3(1,:),Y3(2,:),'b')
hold on
plot(Y4(1,:),Y4(2,:),'b')
% hold on
% plot(Y5(1,:),Y5(2,:),'b')
% hold on
% plot(Y6(1,:),Y6(2,:),,'b'')
% hold on
xlim([0 0.4]);
ylim([-0.1 0.1])
