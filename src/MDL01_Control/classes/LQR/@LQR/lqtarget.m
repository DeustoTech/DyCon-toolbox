function [ uopt, x] = lqtarget(iLQR)
%We look for the optimal pair (uopt, xopt) for the optimal control problem:
%min
%J(u)=\frac{1}{2}[\int_0^T|u(t)-q(t)|^2dt+\beta\int_0^T|C(x(t)-z(t))|^2dt+\gamma\|D(x(T)-z(T))\|^2],
%where
%x_t+Ax=Bu,    t\in (0,T)
%x(0)=x_0.
%The partition of the time interval in the discretization is:
%tout=linspace(0,T,Nt).
%We employ Riccati's theory. We follow the approach of:
%"Contr{\^o}le optimal: th{\'e}orie \& applications",
%by professor Emmanuel Tr{\'e}lat, Proposition 4.4.1 page 60.
%WARNING(1):
%both the control target and the state target are function of time,
%beta\geq 0,
%gamma\geq 0,
%x0\in\mathbb{R}^{size(A,1)}
%T>0
%Nt\in\mathbb{N}.
%WARNING(2):
%Different notation between this code and the aforementioned book.


%%
A = iLQR.Dynamics.A;
B = iLQR.Dynamics.B;
T = iLQR.Dynamics.FinalTime;
Nt = T/ iLQR.Dynamics.dt;
C = iLQR.FunctionalParams.C;
D = iLQR.FunctionalParams.D;
beta =  iLQR.FunctionalParams.beta;
gamma =  iLQR.FunctionalParams.gamma;
z =  iLQR.FunctionalParams.z;
q =  iLQR.FunctionalParams.q;
x0 = iLQR.Dynamics.InitialCondition;
%%
% Size of state vector
n = size(A,1);
% Size of control vector 
m = size(B,2);

%% STEP 1. We solve Riccati Differential Equation
%related to the control problem with zero targets.

[ tout, E ] = RiccatiDiff( A,B,C, D, beta, gamma, T,Nt);

%% STEP 2. Determination of the remainder function h^T.

%We firstly compute \frac{d}{dt}z.
lt=length(tout);
zvect=zeros(lt,n);
for i=1:lt
   zvect(i,:)=z((i/lt)*T);
end

zdervect=zeros(lt,n);
zdervect(1,:)=(zvect(2,:)-zvect(1,:))/(T/lt);
for i=2:lt
    zdervect(i,:)=(zvect(i,:)-zvect(i-1,:))/(T/lt);
end

%We determine \eta(t)=h^T(T-t).
[toutode45, eta] = ode45(@(s, eta) -(transpose(A)*eta+(squeeze(interp1(tout, E, s)))*(B*transpose(B)*eta+(A*z(T-s)+transpose(interp1(tout,zdervect , T-s))-B*q(T-s)))), tout, zeros(n,1));

%we determine h^T,
%by the transformation t--->T-t.
h=zeros(size(eta));
for i=1:lt
       h(i,:)=eta(lt-i+1,:);
end

%STEP 3: We determine the optimal state x
%by solving a closed loop system given by Riccati's operator.

options=odeset('RelTol',1e-12,'AbsTol',1e-14);
[toutode45, x] = ode45(@(s, x) -A*x+B*(-transpose(B)*(squeeze(interp1(tout, E, T-s)))*(x-z(s))-transpose(B)*(transpose(interp1(tout, h, s)))+q(s)), tout, x0,options);

%% 
% STEP 4: We determine optimal control by using the optimal feedback law
%given by Riccati's operator.

uopt=zeros(lt,m);

for i=1:lt
    uopt(i,:)=-transpose(B)*(squeeze(E(lt-i+1,:,:))*(transpose(x(i,:))-z(((i-1)/lt)*T)))-transpose(B)*(transpose(h(i,:)))+q((i/lt)*T);
end

%We plot the optimal pair
%(optimal control, optimal state)
%in case m <= 2 and n>=2.

%We construct the vectors
%ct and st containing the values
%resp. of the state target and the control target
%corresponding to the time instances in the partion tout.

ct=zeros(Nt,m);
st=zeros(Nt,n); 
for i=1:lt
    ct(i,:)=transpose(q(tout(i)));
    st(i,:)=transpose(z(tout(i)));
end                


end



