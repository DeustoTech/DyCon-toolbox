clear;
%% Los vectores symY = [ varphi1 varphi2 varphi3 varphi4 ]
%%              symU = [ psi1 psi2 psi3 psi4 ]
syms t

%% Creamos Funcional  

%% 
%In the present script, we set up
%the control problem to model
%https://www.marposs.com/eng/product/flange-and-spindle-type-balancing-heads
%The mathematical model we choose is suggested by
%\cite{mencuccini2016fisica} page 215, E.6.13.

%WARNING:
%\cup_{i\in \left\{1,\dots, 6\right\} Ci
%is a system of mass-points.
%It might not be a rigid body.
%% Description of the model.


%% Variables.

% radii cyilinders.
syms r1 r21 r22 r31 r32 r33

% heights cylinders.
syms h1 h2 h31 h32

% angles "negative" cylinders.
syms theta31 theta32

% angles indicating the position of the 4 balancing cilinders.
syms varphi1 varphi2 varphi3 varphi4

%WARNING
%the notation for the angles varphi above
%is different with respect to
%Remark (2/12/2018_0186).

% masses cylinders.
syms M1 M2 M3 M4 M41 M42

%% Center of mass.
%of the rigid body
%\cup_{i\in \left\{1,\dots,6\right}}C_i.

%The center of mass for C_1\cup C_2 is assumed to be a given
%function of time.
% 
% syms rCC1C2x(t)
% syms rCC1C2y(t)
% syms rCC1C2z(t)

%We compute r_C for a generic cilinder
%C(r1,r2,theta1,theta2,q,h) of mass M
%See Remark(2/12/2018_01)

%% Example.

syms rdeform qdeform hdeform Mdeform

%angular velocity.
syms omega

%The spindle C1 is homogeneus cilinder;
%The grinder have the same matrix of inertia of
%C(r21,r22,0,h2,0,2*(pi))\setminus C(rdeform,r22,qdeform,hdeform,omega*t,(pi)/2+omega*t)

%WARNING:
%If the cylinder subtrcted to deform is
%with theta1=0, theta2=2*(pi),
%I_{xz}=0, and I_{y,z}=0.

%WARNING:
%The center of masss of
%C(r21,r22,0,h2,0,2*(pi))\setminus C(rdeform,r22,qdeform,hdeform,omega*t,(pi)/2+omega*t)
%might not be on the axis of rotation.

syms r1 r2 theta1 theta2 q h M
%syms rCgenx rCgeny rCgenz

rCgenx=2*(r2^3-r1^3)*(sin(theta2)-sin(theta1))/(3*(r2^2-r1^2)*(theta2-theta1));
rCgeny=2*(r2^3-r1^3)*(cos(theta1)-cos(theta2))/(3*(r2^2-r1^2)*(theta2-theta1));
rCgenz=q;

syms rCC1x rCC1y

%The spindle is an homogeneus cylinder.

rCC1x=0;
rCC1y=0;

syms IxzC1 IyzC1

IxzC1=0;
IyzC1=0;

syms rCC2x rCC2y

rCC2x=(M2*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r21,r22,0,2*(3.14),0,h2,M2})-Mdeform*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{rdeform,r22,omega*t,(3.14)/2+omega*t,qdeform,hdeform,Mdeform}))/(M2-Mdeform);
rCC2y=(M2*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r21,r22,0,2*(3.14),0,h2,M2})-Mdeform*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{rdeform,r22,omega*t,(3.14)/2+omega*t,qdeform,hdeform,Mdeform}))/(M2-Mdeform);

syms r1 r2 theta1 theta2 q h M
%syms Ixzgen Iyzgen

Ixzgen=2*M*q*(r2^3-r1^3)*(sin(theta2)-sin(theta1))/(3*(r2^2-r1^2)*(theta2-theta1));
Iyzgen=2*M*q*(r2^3-r1^3)*(cos(theta1)-cos(theta2))/(3*(r2^2-r1^2)*(theta2-theta1));

syms IxzC2 IyzC2

IxzC2=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r21,r22,0,2*(3.14),0,h2,M2})-subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{rdeform,r22,omega*t,(3.14)/2+omega*t,qdeform,hdeform,Mdeform});
IyzC2=subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r21,r22,0,2*(3.14),0,h2,M2})-subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{rdeform,r22,omega*t,(3.14)/2+omega*t,qdeform,hdeform,Mdeform});

syms rCC1C2x
syms rCC1C2y

rCC1C2x=rCC1x+rCC2x;
rCC1C2y=rCC1y+rCC2y;

syms IxzC1C2
syms IyzC1C2

IxzC1C2=IxzC1+IxzC2;
IyzC1C2=IyzC1+IyzC2;

%WARNING: Check the computation of \frac{d^2}{dt^2}r_C,
%in light of E.II.24 page 25 of \cite{mencuccini2016fisica}.

%We compute rCC3x, rCC3y and rCC3z for C_3.

syms rCC3x rCC3y rCC3z

rCC3x=subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi1,varphi1+((3.14)/2),(h2+h31)/2,h31,M3});
rCC3y=subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi1,varphi1+((3.14)/2),(h2+h31)/2,h31,M3});
rCC3z=subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi1,varphi1+((3.14)/2),(h2+h31)/2,h31,M3});

%We compute rCC4x, rCC4y and rCC4z for C_4.

syms rCC4x rCC4y rCC4z

rCC4x=(M41*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2,varphi2+((3.14))/2,(h2+h31)/2,h31,M41})-M42*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42}))/(M41-M42);
rCC4y=(M41*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2,varphi2+((3.14))/2,(h2+h31)/2,h31,M41})-M42*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42}))/(M41-M42);
rCC4z=(M41*subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2,varphi2+((3.14))/2,(h2+h31)/2,h31,M41})-M42*subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42}))/(M41-M42);

%We compute rCC5x, rCC5y and rCC5z for C_5.

syms rCC5x rCC5y rCC5z

rCC5x=subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi3,varphi3+((3.14)/2),-(h2+h31)/2,h31,M3});
rCC5y=subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi3,varphi3+((3.14)/2),-(h2+h31)/2,h31,M3});
rCC5z=subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi3,varphi3+((3.14)/2),-(h2+h31)/2,h31,M3});

%We compute rCC6x, rCC6y and rCC6z for C_6.

syms rCC6x rCC6y rCC6z

rCC6x=(M41*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4,varphi4+((3.14))/2,-(h2+h31)/2,h31,M41})-M42*subs(rCgenx,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4+theta31,varphi4+theta32,-(h2+h31)/2,h32,M42}))/(M41-M42);
rCC6y=(M41*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4,varphi4+((3.14))/2,-(h2+h31)/2,h31,M41})-M42*subs(rCgeny,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4+theta31,varphi4+theta32,-(h2+h31)/2,h32,M42}))/(M41-M42);
rCC6z=(M41*subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4,varphi4+((3.14))/2,-(h2+h31)/2,h31,M41})-M42*subs(rCgenz,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4+theta31,varphi4+theta32,-(h2+h31)/2,h32,M42}))/(M41-M42);

%We compute rCC3456x, rCC3456y and rCC3456z for \cup_{i\in\left\{1,\dots,6\right\} C_i.

syms rCC3456x rCC3456y rCC3456z

rCC3456x=(M3*rCC3x+M4*rCC4x+M3*rCC5x+M4*rCC6x)/(2*(M41+M42));
rCC3456y=(M3*rCC3y+M4*rCC4y+M3*rCC5y+M4*rCC6y)/(2*(M41+M42));
rCC3456z=(M3*rCC3z+M4*rCC4z+M3*rCC5z+M4*rCC6z)/(2*(M41+M42));

%We define the center of mass of the
%system of mass-points
%\cup_{i\in \left\{1,\dots, 6\right\} Ci.

syms rCx(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)
syms rCy(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)
%syms rCz(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)

rCx(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)=((M1+M2)*rCC1C2x+(2*(M3+M4))*rCC3456x)/(M1+M2+2*(M3+M4));
rCy(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)=((M1+M2)*rCC1C2y+(2*(M3+M4))*rCC3456y)/(M1+M2+2*(M3+M4));
%% Matrix of inertia
%of the rigid body
%\cup_{i\in \left\{1,\dots,6\right}}C_i.

% We consider only -I_{xz}, -I_{yz}.
% See Remark (2/12/2018_0186).

% %The matrix of inertia for C_1\cup C_2 is assumed to be a given
% %function of time.
% 
% syms IxzC1C2(t)
% syms IyzC1C2(t)

%We compute I_{xz} and I_{yz} for a generic cilinder
%C(r1,r2,theta1,theta2,q,h) of mass M
%See Remark(2/12/2018_01)

%We compute now I_{xz} and I_{yz} for C_3.

syms IxzC3 IyzC3

IxzC3=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi1,varphi1+((3.14)/2),(h2+h31)/2,h31,M3});
IyzC3=subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi1,varphi1+((3.14)/2),(h2+h31)/2,h31,M3});

%We compute now I_{xz} and I_{yz} for C_4.

syms IxzC4 IyzC4

%provisional.
%IxzC42=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42})

IxzC4=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2,varphi2+((3.14))/2,(h2+h31)/2,h31,M41})-subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42});
IyzC4=subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2,varphi2+((3.14))/2,(h2+h31)/2,h31,M41})-subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi2+theta31,varphi2+theta32,(h2+h31)/2,h32,M42});


%We compute now I_{xz} and I_{yz} for C_5.

syms IxzC5 IyzC5

IxzC5=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi3,varphi3+((3.14)/2),-(h2+h31)/2,h31,M3});
IyzC5=subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r31,r32,varphi3,varphi3+((3.14)/2),-(h2+h31)/2,h31,M3});

%We compute now I_{xz} and I_{yz} for C_6.

syms IxzC6 IyzC6

IxzC6=subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4,varphi4+((3.14))/2,-(h2+h31)/2,h31,M41})-subs(Ixzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4+theta31,varphi4+theta32,-(h2+h31)/2,h32,M42});
IyzC6=subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4,varphi4+((3.14))/2,-(h2+h31)/2,h31,M41})-subs(Iyzgen,{r1,r2,theta1,theta2,q,h,M},{r32,r33,varphi4+theta31,varphi4+theta32,-(h2+h31)/2,h32,M42});

%We compute I_{xz} for \cup_{i\in\left\{3,\dots,6\right\} C_i.

syms IxzC3456 IyzC3456

IxzC3456=IxzC3+IxzC4+IxzC5+IxzC6;
IyzC3456=IyzC3+IyzC4+IyzC5+IyzC6;

%We define the I_{x,z} and I_{y,z} of the
%system of mass-points
%\cup_{i\in \left\{1,\dots, 6\right\} Ci.

syms Ixz(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)
syms Iyz(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)

Ixz(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)=IxzC1C2+IxzC3456;
Iyz(varphi1,varphi2,varphi3,varphi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42)=IyzC1C2+IyzC3456;

%% Lagrangian function.



%parameters defining weights for the functional.
syms gamma beta

%velocities.
syms psi1 psi2 psi3 psi4

syms L(varphi1,varphi2,varphi3,varphi4,psi1,psi2,psi3,psi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42,omega,gamma,beta)

L(varphi1,varphi2,varphi3,varphi4,psi1,psi2,psi3,psi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42,omega,gamma,beta,rdeform,qdeform,hdeform,Mdeform)=((beta)/2)*(psi1^2+psi2^2+psi3^2+psi4^2)+(1/2)*(rCx^2+rCy^2)+(gamma/2)*(omega)^2*(Ixz^2+Iyz^2);


%% Example

r1=1;
r21=r1;
r22=6;
r31=r1;
r32=2;
r33=3;
h1=12;
h2=8;
h31=2;
h32=0.3;
theta31=(3.14)/4;
theta32=3*(3.14)/4;
M1=1;
M2=6;
M3=1;
M4=1;
M41=0.8;
M42=0.2;
omega=6;
gamma=1;
beta=10^(-6);
rdeform=0.1;
qdeform=1;
hdeform=0.15;
Mdeform=0.3;


symL=L(varphi1,varphi2,varphi3,varphi4,psi1,psi2,psi3,psi4,t,r1,r21,r22,r31,r32,r33,h1,h2,h31,h32,theta31,theta32,M1,M2,M3,M4,M41,M42,omega,gamma,beta,rdeform,qdeform,hdeform,Mdeform)

symY = SymsVector('y',4);
symU = SymsVector('u',4);
 
symL = subs(symL,{varphi1,varphi2,varphi3,varphi4},{symY(1),symY(2),symY(3),symY(4)});
symL = subs(symL,{psi1,psi2,psi3,psi4},{symU(1),symU(2),symU(3),symU(4)});

symPsi  = 0;
T = 5;

Jfun = Functional(symPsi,symL,symY,symU,'T',T);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%
Y0 = ones(4,1);

%%%%%%%%%%%%%%%%
Fsym  = symU;
%%%%%%%%%%%%%%%%
odeEqn = ode(Fsym,symY,symU,Y0,'T',T);

%% Creamos Problema de Control
iCP1 = ControlProblem(odeEqn,Jfun);

%% Solve Gradient

DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',1e-8,'MinLengthStep',1e-15};
Gradient_Parameters = {'maxiter',50,'DescentParameters',DescentParameters,'Graphs',true};
GradientMethod(iCP1,Gradient_Parameters{:})




% view res
%  animation(odeEqn)
% animation(odeEqn,'YLim',[-2 5],'xx',2.0)
