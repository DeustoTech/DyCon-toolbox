%%
%% Semi-linear semi-discrete heat equation and collective behavior
%%
% Definition of the time 
clear 
syms t
% Discretization of the space
N = 30;
L = 1;
xi = 0; xf = L;
xline = linspace(xi,xf,N+2);
xline = xline(2:end-1);

%%
symY = SymsVector('y',N);
symU = SymsVector('u',1);
%%
% We create the functional that we want to minimize
% Our goal is to set the system to zero penalizing the norm of the control
% by a parameter $\beta$ that will be small.
YT = 0.2 + 0*xline';
dx = xline(2) - xline(1);
symPsi  = @(T,symY) (YT - symY).'*(YT - symY);
%tiempo= @(t) piecewise(t<=T/2,500,t>T/2,0);
symL    = @(t,symY,symU) 0 ;
%%
% We create the ODE object
% Our ODE object will have the semi-discretization of the semilinear heat equation.
% We set also initial conditions, define the non linearity and the interaction of the control to the dynamics.
%%
% Initial condition
%Y0 = 2*sin(pi*xline)';
Y0 = 0.99+0*xline';
%%
% Diffusion part: the discretization of the 1d Laplacian
A=(N^2/L^2)*(full(gallery('tridiag',N,1,-2,1)));
% A(1,1)=0;
% A(1,2)=0;
% A(end,end)=0;
% A(end,end-1)=0;
%%
% We define the matrix B that will be the effect of the interior control to the dynamics
B = zeros(N,1);
B(1,1) = 1;
B(end,end) = 1;
B = (N^2/L^2)*B;
%%
% Definition of the non-linearity
% $$ \partial_y[-5\exp(-y^2)] $$
%%
syms x;
syms G(x);
syms U(x);
syms DG(x);
%U(x)=-5*exp(-x^2);
%G(x)=diff(U,x);
G(x)=x*(1-x)*(x-0.2);
formula=G(x);
G = symfun(formula,x)
%%
% and we define the part of the dynamics corresponding to the nonlinearity
vectorF = arrayfun( @(x)G(x),symY);
%%

% Putting all the things together
Fsym  = A*symY + vectorF + B*symU;
syms t
Fsym_fh = matlabFunction(Fsym,'Vars',{t,symY,symU,sym.empty});
%%
odeEqn = pde(Fsym_fh,symY,symU,'InitialCondition',Y0,'FinalTime',2.0);
odeEqn.Nt=200;
odeEqn.mesh = xline;
odeEqn.Solver = @ode23tb;
%%
% We solve the equation and we plot the free solution applying solve to odeEqn and we plot the free solution.
%%
solve(odeEqn)
%%
figure;
surf(odeEqn.StateVector.Numeric,'EdgeColor','none');
title('Free Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
% We create the object that collects the formulation of an optimal control problem  by means of the object that describes the dynamics odeEqn, the functional to minimize Jfun and the time horizon T
%%
iCP1 = Pontryagin(odeEqn,symPsi,symL);
%
iCP1.Constraints.MaxControl = 1;
iCP1.Constraints.MinControl = 0;

%%
AMPLFileFixedFinalTime(iCP1,'Domenec.txt')
out = SendNeosServer('Domenec.txt')

data = NeosLoadData(out)
%%
U = zeros(odeEqn.Nt,odeEqn.ControlDimension);
Y = zeros(odeEqn.Nt,odeEqn.StateDimension);

GetSymCrossDerivatives(iCP1)

GetSymCrossDerivatives(iCP1.Dynamics)
  
YU0 = [Y U];
Udim = odeEqn.ControlDimension;
Ydim = odeEqn.StateDimension;

options = optimoptions('fmincon','display','iter',    ...
                       'MaxFunctionEvaluations',1e6,  ...
                       'SpecifyObjectiveGradient',true, ...
                       'CheckGradients',false,          ...
                       'SpecifyConstraintGradient',true)% , ...
                        %'HessianFcn',@(YU,Lambda) Hessian(iCP1,YU,Lambda));
%
funobj = @(YU) StateControl2DiscrFunctional(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end));

Yup = Y + Inf;
Ydown = Y - Inf;
Uup = Y + 1;
Udown = Y - 0;

YUdown = [Ydown Udown];
YUup = [Yup Uup];


clear ConstraintDynamics
YU = fmincon(funobj,YU0, ...
           [],[], ...
           [],[], ...
           YUdown,YUup, ...
           @(YU) ConstraintDynamics(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end)),    ...
           options);

iCP1.Dynamics.StateVector.Numeric = YU(:,1:Ydim);
iCP1.Dynamics.Control.Numeric = YU(:,Ydim+1:end);


%%
% We apply the steepest descent method to obtain a local minimum (our functional might not be convex).
% 
iCP1.Constraints.MaxControl = [];
iCP1.Constraints.MinControl = [];
U0 = 0.0*(iCP1.Dynamics.tspan).' + 0.1;
U0(U0>1) = 1;
U0(U0<0) = 0;

%U0 = zeros(length(iCP1.Dynamics.tspan),iCP1.Dynamics.ControlDimension)+ 0.6;
GradientMethod(iCP1,U0,'display','all','DescentAlgorithm',@AdaptativeDescent,'Graphs',false,'display','all')

%%
% U0 = zeros(length(iCP1.Dynamics.tspan),iCP1.Dynamics.Udim)+ 0;
% options = optimoptions(@fminunc,'SpecifyObjectiveGradient',true,'display','iter');
% fminunc(@(U) Control2Functional(iCP1,U),U0,options)

%%  
%  options = optimoptions('ga','display','iter', ...
%                               'HybridFcn',{'fmincon','SpecifyObjectiveGradient',true},'UseParallel',false);
% ga(@(U) Control2Functional(iCP1,U'),odeEqn.Nt,[],[],[],[],U0*0 ,U0*0 + 1,[],options)
% 
%%
options = optimoptions(@fmincon,'SpecifyObjectiveGradient',true,'display','iter');
U0 = zeros(length(iCP1.Dynamics.tspan),iCP1.Dynamics.ControlDimension)+ 0.66;
U0 = 0.1*(iCP1.Dynamics.tspan.^0.5).';

fmincon(@(U) Control2Functional(iCP1,U),U0,[],[], ...
                                           [],[], ... 
                                           U0*0 ,U0*0 + 1, ... % lb - yp
                                           [],options)

%%
figure;
SIZ=size(iCP1.Dynamics.StateVector.Numeric);

surf(iCP1.Dynamics.StateVector.Numeric,'EdgeColor','none')
title('Controlled Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
% The control function inside the control region
figure;
% SIZ=size(iCP1.Dynamics.Control.Numeric);
% time=linspace(0,T,SIZ(1));
% space=linspace(1,SIZ(2)-1,SIZ(2)-1);
% [TIME,SPACE]=meshgrid(time,space);
% surf(iCP1.Dynamics.Control.Numeric,'EdgeColor','none')
% title('Control')
% ylabel('space discretization')
% xlabel('Time')
plot(iCP1.Dynamics.Control.Numeric)
%%
figure;
line(xline,YT,'Color','red')
line(xline,odeEqn.StateVector.Numeric(end,:),'Color','blue')
line(xline,iCP1.Dynamics.StateVector.Numeric(end,:),'Color','green')
legend('Target','Free Dynamics','controlled dynamics')
%%
error('sda')
%%
% Now we apply the same procedure for the collective
% behavior dynamics.
%%
% We will employ a function that does the algorithm explained before for
% the semilinear heat equation having the chance to set a diffusivity
% constant.
%%
% We set the parameters for the function
beta=0.0000001;
y0=@(x)2*sin(pi*x);
syms x
syms G(x);
syms U(x);
syms DG(x);
U(x)=-5*exp(-x^2);
G(x)=diff(U,x);
T=1;
N=50;
%%
% For the simulation of the model in collective behavior we will employ a
% diffusivity $D=\frac{1}{N^3}$.
%%
[a,b,c,d]=SLSD1doptimalnullcontrol_T007_semilinear(N,1/(N^3),G,T,beta,[0.5,0.8],y0);
%%
figure;
surf(a.time,a.space,a.value,'EdgeColor','none');
title('Free Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
figure;
surf(b.time,b.space,b.value,'EdgeColor','none')
title('Controlled Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
figure;
surf(c.time,c.space,c.value,'EdgeColor','none')
title('Control')
ylabel('space discretization')
xlabel('Time')
%%
xline = linspace(xi,xf,N);
figure;
line(xline,d.y1,'Color','red')
line(xline,d.y2,'Color','blue')
line(xline,d.y3,'Color','green')
legend('Target','Free Dynamics','controlled dynamics')
%%
% Now we will change also the time horizon and we will incorporate a
% non-homogeneous non-linearity, we will just divide the non-linearity $G$
% by $N^3$
%%
[a,b,c,d]=SLSD1doptimalnullcontrol_T007_semilinear(N,1/(N^2),G/(N^2),N^2*T,beta,[0.5,0.8],y0);
%%

figure;
surf(a.time,a.space,a.value,'EdgeColor','none');
shading interp; colormap jet
title('Free Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
figure;
surf(b.time,b.space,b.value,'EdgeColor','none')
shading interp; colormap jet
title('Controlled Dynamics')
ylabel('space discretization')
xlabel('Time')
%%
figure;
surf(c.time,c.space,c.value,'EdgeColor','none')
shading interp; colormap jet
title('Control')
ylabel('space discretization')
xlabel('Time')
%%
figure;
xline = linspace(xi,xf,N);
line(xline,d.y1,'Color','red')
line(xline,d.y2,'Color','blue')
line(xline,d.y3,'Color','green')
legend('Target','Free Dynamics','controlled dynamics')


