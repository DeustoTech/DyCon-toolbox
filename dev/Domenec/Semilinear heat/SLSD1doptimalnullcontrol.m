function [freedynamics,controlleddynamics,ucontrol,iCP2]=SLSD1doptimalnullcontrol(N,D,G,T,beta,w,y0)
normscb=0;
targnormscb=0;
syms t;
% Discretization of the space
xi = 0; 
xf = 1;
xline = linspace(xi,xf,N);
w1=w(1);
w2=w(2);
count=1;
for i=1:N
    if (double(i-1))/double(N) > w1
        if (i-1)/double(N) < w2
            count=count+1;
        end
    end
end
%%
symY = SymsVector('y',N);
symU = SymsVector('u',count);
% We create the functional that we want to minimize
YT = 0*xline';
symPsi  = (YT - symY).'*(YT - symY);
symL    = beta*(symU.'*symU)*(abs(w1-w2))/count;
% Jfun = Functional(symPsi,symL,symY,symU);
% We create the ODE object
% Our ODE object will have the semi-discretization of the semilinear heat equation.
% We set also initial conditions, define the non linearity and the interaction of the control to the dynamics.
%%
% Initial condition
Y0 = y0(xline)';
%%
% Diffusion part
A=D*N^2*(full(gallery('tridiag',N,1,-2,1)));
%%
% Effect of the interior control to the dynamics
B = zeros(N,count);
count2=1;
for i=1:N
    if (i-1)/double(N) >= w1
        if (i-1)/double(N) < w2
            B(i,count2)=1;
            count2=count2+1;
        end
    end
end
%%
% Definition of the non-linearity
syms x;
formula=G(x);%*(1/N^3);
G = symfun(formula,x);
vectorF = arrayfun( @(x)G(x),symY);
%%
% Putting all the things together
Fsym  = A*symY + vectorF + B*symU;
% Time horizon
T = T;
%%
% We create the ODE-object and we change the resolution to dt=0.01 in order
% to see the variation in a small time scale. We will get the values of the
% solution in steps of size odeEqn.dt, if we do not care about
% modifying this parameter in the object, we might get the solution in
% certain time steps that will hide part of the dynamics.
%%
odeEqn2 = ode(Fsym,symY,symU,'Condition',Y0,'FinalTime',T);
odeEqn2.RKMethod = @ode23tb;
%odeEqn2 = ode(Fsym,symY,symU,'Y0',Y0,'T',T);
%odeEqn2.dt=0.01;
iCP2 = OptimalControl(odeEqn2,symPsi,symL);%Jfun,'T',T);
GradientMethod(iCP2,'DescentAlgorithm',@AdaptativeDescent,'Maxiter',400,'tol',0.005,'Graphs',true,'TypeGraphs','PDE','DescentParameters',{'StopCriteria','absolute','norm','L2'});
%%
% We solve the equation and we plot the free solution applying solve to odeEqn and we plot the free solution.
%%
solve(odeEqn2)
%%
SIZ=size(odeEqn2.VectorState.Numeric);
time=linspace(0,T,SIZ(1));
space=linspace(1,N,N);
[TIME,SPACE]=meshgrid(time,space);
freedynamics.time=TIME';
freedynamics.space=SPACE';
freedynamics.value=odeEqn2.VectorState.Numeric;

%%
% f2=figure;
% line(xline,YT,'Color','red')
% line(xline,odeEqn2.Y(end,:),'Color','blue')
% legend('Target','Free Dynamics')
% We create the object that collects the formulation of an optimal control problem by means of the object that describes the dynamics odeEqn, the functional to minimize Jfun and the time horizon T
%%
% Jfun = Functional(symPsi,symL,symY,symU);
%iCP2 = ControlProblem(odeEqn2,symPsi,symL);%Jfun,'T',T);
%%
% We apply the steepest descent method to obtain a local minimum (our functional might not be convex).
%tol = 10^(-5);
%maxiter = 300;

%GradientMethod(iCP2,'DescentAlgorithm',@AdaptativeDescent);%,ConjugateGradientDescent();
%Ucg=iCP2.

% DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',4.0,'MinLengthStep',10^(-13)};
% GradientParameters = {'tol',tol,'DescentParameters',DescentParameters,'graphs',true,'TypeGraphs','PDE','maxiter',maxiter};
%
%outputs=MontecarloGradient(iCP2,10,1,GradientParameters,0,5,'pde',1,'single')
% GradientMethod(iCP2,GradientParameters{:},'U0',Ucg)
%% function[output]=MontecarloGradient(iCP,Nseeds,norm,GradientParameters,positivity,v)

SIZ=size(iCP2.ode.VectorState.Numeric);
time=linspace(0,T,SIZ(1));
space=linspace(1,N,N);
[TIME,SPACE]=meshgrid(time,space);
controlleddynamics.time=TIME';
controlleddynamics.space=SPACE';
controlleddynamics.value=iCP2.ode.VectorState.Numeric;
%%
SIZ=size(iCP2.solution.UOptimal);
time=linspace(0,T,SIZ(1));
space=linspace(1,SIZ(2),SIZ(2));
[TIME,SPACE]=meshgrid(time,space);
ucontrol.time=TIME';
ucontrol.space=SPACE';
ucontrol.value=iCP2.solution.UOptimal;

%%
% targetplusdynamicspluscontrol.y1=YT;
% targetplusdynamicspluscontrol.y2=odeEqn2.Y(end,:);
% targetplusdynamicspluscontrol.y3=iCP2.ode.Y(end,:);
%%
uu=iCP2.solution.UOptimal;
for j=1:length(uu(:,1))
normscb=normscb+(uu(j,:)*uu(j,:)')*(abs(w1-w2))/count;
end 
for j=size(iCP2.ode.VectorState.Numeric(end,:))
targnormscb=targnormscb+iCP2.ode.VectorState.Numeric(end,j)^2;
end
targnormscb/N;
end
