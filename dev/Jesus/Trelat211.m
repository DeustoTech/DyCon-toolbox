function tirsimple
% Methode de tir simple, en utilisant fsolve.m,
% pour le systeme de controle
% xdot=y, ydot=u, |u|<=1.
% On veut aller de (0,0) \‘a (0,-1) en temps minimal.
clear all ; clf ; clc ; format long ;
global x0 ; x0=[0;0] ;
P0=[1;1] ; tf=5 ;
% Calcul de P0,tf
options=optimset(’Display’,’iter’,’LargeScale’,’on’);
[P0tf,FVAL,EXITFLAG]=fsolve(@F,[P0;tf],options);
EXITFLAG % 1 si la methode converge, -1 sinon
% Trace de la trajectoire optimale
options = odeset(’AbsTol’,1e-9,’RelTol’,1e-9) ;
[t,z] = ode45(@sys,[0;P0tf(3)],[x0;P0tf(1);P0tf(2)],options) ;
subplot(121) ; plot(z(:,1),z(:,2)) ;
axis square ; title(’Trajectoire’) ;
subplot(122) ; plot(t,sign(z(:,4))) ;
axis square ; title(’Controle’) ;
%-------------------------------------------------------------