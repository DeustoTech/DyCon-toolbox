function [freedynamics,controlleddynamics,ucontrol,targetplusdynamicspluscontrol]=SLSD1doptimalnullcontrol(N,D,G,T,beta,w,y0)
% visible: true
% author: Domenec
% date: 2018-12-19
% description: This function computes an approximate null-control for the semilinear heat equation. Consider the semilinear 
%               heat equation in the interval $[0,1]$ with interior control, $$y_t-Dy_{xx}=G(y)+u\mathbb{1}_\omega$$ with 
%               0 Dirichlet boundary conditions. The control is computed via an optimal control problem. WARNING the control
%               might be non optimum with respect to the functional. It will depend on the non-linearity considered in the heat 
%               equation, the convexity of the functional has to be proven. Given the time horizon for the control $T>0$, the
%               functional considered is $$J(y,u)=\|y(T)\|_{L^2(\Omega)}+\beta\int_0^T \|u(t)\|^2_{L^2(\Omega)}dt.$$ Computations
%               are done with the DyCon toolbox considering a semi-discretization on space and integrating the ODE system.
% MandatoryInputs:  
%   N:
%       class:        integer
%       dimension:   1
%       description: Number of interior points in the semi-discretization
%   D:
%       class:         double
%       dimension:    1
%       description:  Diffusivity constant  
%   G:
%       class:        symbolic expression
%       dimension:   1
%       description: Symbolic expression of the non-linearity
%   T:
%       class:        double
%       dimension:   1
%       description: Time horizon
%   beta:
%       class:        double
%       dimension:   1
%       description: parameter in the functional $J$
%   w:
%       class:        double
%       dimension:   2
%       description: vector containing the borders of the interior control region
%   beta:
%       class:        handle function
%       dimension:   1
%       description: handle function containing the initial data $y_0$
% Outputs:
%   freedynamics:
%       class:        structure
%       dimension:   1x1
%       description: the structure contains the necessary data for plotting the free dynamics i.e. the dynamics without control.
%                       <ul>
%                           <li>freedynamics.time is the time mesh</li>
%                           <li>freedynamics.space is the space mesh</li>
%                           <li>freedynamics.value is the values of the solution in the mesh</li>
%                       </ul>
%   controlleddynamics:
%       class:        structure
%       dimension:   1x1
%       description: the structure contains the necessary data for plotting the controlled dynamics i.e. the dynamics with the control computed via gradient descent over the functional.
%                       <ul>
%                           <li>controlleddynamics.time is the time mesh</li>
%                           <li>controlleddynamics.space is the space mesh</li>
%                           <li>controlleddynamics.value is the values of the solution in the mesh</li>
%                       </ul>
%   ucontrol:
%       class:        structure
%       dimension:   1x1
%       description: the structure contains the necessary data for plotting the computed control in the control region.
%                       <ul>
%                           <li>ucontrol.time is the time mesh</li>
%                           <li>ucontrol.space is the space mesh</li>
%                           <li>ucontrol.value is the values of the control in the mesh corresponding to the control region</li>
%                       </ul>
%   targetplusdynamicspluscontrol:
%       class:        structure
%       dimension:   1x1
%       description: the structure contains the necessary data for plotting the free dynamics at time $T$ the control dynamics at time $T$ and the desired target (the function 0).
%                       <ul>
%                            <li>targetplusdynamicspluscontrol.y1 is the target </li>
%                            <li>targetplusdynamicspluscontrol.y2 is the free dynamics at time $T$</li>
%                            <li>targetplusdynamicspluscontrol.y3 is the dynamics with control at time $T$. </li>
%                       </ul>
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
%%
syms x;
formula=G(x);%*(1/N^3);
G = symfun(formula,x);
vectorF = arrayfun( @(x)G(x),symY);
%%
% Putting all the things together
Fsym  = A*symY + vectorF + B*symU;
%%
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
odeEqn2.dt=0.01;
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
iCP2 = OptimalControl(odeEqn2,symPsi,symL);
%%
% We apply the steepest descent method to obtain a local minimum (our functional might not be convex).
%
GradientMethod(iCP2)
%%
SIZ=size(iCP2.ode.VectorState.Numeric);
time=linspace(0,T,SIZ(1));
space=linspace(1,N,N);
[TIME,SPACE]=meshgrid(time,space);
controlleddynamics.time=TIME';
controlleddynamics.space=SPACE';
controlleddynamics.value=iCP2.ode.VectorState.Numeric;
title('Controlled Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
SIZ=size(iCP2.solution.UOptimal);
time=linspace(0,T,SIZ(1));
space=linspace(1,SIZ(2),SIZ(2));
[TIME,SPACE]=meshgrid(time,space);
ucontrol.time=TIME';
ucontrol.space=SPACE';
ucontrol.value=iCP2.solution.UOptimal;

%%
targetplusdynamicspluscontrol.y1=YT;
targetplusdynamicspluscontrol.y2=odeEqn2.VectorState.Numeric(end,:);
targetplusdynamicspluscontrol.y3=iCP2.ode.VectorState.Numeric(end,:);
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
