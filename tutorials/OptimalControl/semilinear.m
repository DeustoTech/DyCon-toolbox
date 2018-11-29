clear;
%% Los vectores symY = [ y1 y2 ]
%%              symU = [ u1 u2 ]
syms t
%% Discretizacion del espacio
N = 11;
xi = 0; xf = 1;
xline = linspace(xi,xf,N);

%% Control size
w1=0.5;
w2=0.6;

count=1;
for i=1:N
    if (double(i-1))/double(N) > w1
        if (i-1)/double(N) < w2
            count=count+1;
        end
    end
end


symY = SymsVector('y',N);
symU = SymsVector('u',count);
%% Creamos Funcional

YT = 0*xline';
%symPsi  = (YT - symY).'*(YT - symY);
symPsi  = 0;
symL    = (YT - symY).'*(YT - symY)+0.001*(symU.'*symU)*(abs(w1-w2))/count;

Jfun = Functional(symPsi,symL,symY,symU);

%% Creamos el ODE 
%%%%%%%%%%%%%%%%

Y0 = 2*sin(pi*xline)';
%%%%%%%%%%%%%%%%



A=(N^2)*(full(gallery('tridiag',N,1,-2,1)));
%%%%%%%%%%%%%%%%  
%B = zeros(N,2);
%B(1,1) = 1;
%B(N,2) = 1;


B = zeros(N,count);
count2=1;
for i=1:N
    if (i-1)/double(N) > w1
        if (i-1)/double(N) < w2
            B(i,count2)=1;
            count2=count2+1;
        end
    end
end

a=5;
c=0.20;
%syms G(x);
syms x;
syms G;

syms x;
syms G(x);
syms U(x);
syms DG(x);
U(x)=-20*exp(-x^2);
G(x)=diff(U,x);



formula=G(x);

G = symfun(formula,x);

%G(x) = piecewise(x<=-a, -2*a^2*x*c-2*a*a*a*c, a<=x, -2*a*a*x*c+2*a*a*a*c, -a<x<a, -c*x*(x-a)*(x+a));
%GF=@(x) double(G(x));

vectorF = arrayfun( @(x)G(x),symY);

% B=zeros(N,N);
% count=0;
% for i=ceil(Nx*w1):floor(Nx*w2)
%     B(i,i)=1;
%     count=count+1;
% end
%%%%%%%%%%%%%%%%
Fsym  = A*symY + vectorF + B*symU;
%%%%%%%%%%%%%%%%
T = 20;
odeEqn = ode(Fsym,symY,symU,'Y0',Y0,'T',T);


%% Veamos que queremos 

solve(odeEqn)

line(xline,YT,'Color','red')
line(xline,odeEqn.Y(end,:),'Color','blue')
legend('Target','Free Dynamics')

%% Creamos Problema de Control

iCP1 = ControlProblem(odeEqn,Jfun,'T',T);

%% Solve Gradient
tol = 0.1;
maxiter = 30;
DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',4.0};
GradientParameters = {'tol',tol,'DescentParameters',DescentParameters,'graphs',true,'UGraphs','X','maxiter',maxiter};
%
GradientMethod(iCP1,GradientParameters{:})
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)


