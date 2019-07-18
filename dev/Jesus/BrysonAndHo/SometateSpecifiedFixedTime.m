close all
clear all
%% Domain


delta = 1e-3;






mat = rand([20,2]);
mat(:,1) = 400*mat(:,1) - 200;
mat(:,2) = 120*mat(:,2) - 60;

UVrand = @(x,y) UV(x,y,mat);
[quiverObj ,ax] = CreateVectorField(UVrand);

%% Dynamics Definition
syms t
 
syms x y
% Control
syms Theta V
F = [ V*cos(Theta)  ;  V*sin(Theta) ]   + UVrand(x,y).';   

State = [x y].';
Control = [Theta V].';
F = matlabFunction(F,'Vars',{t,State,Control,sym.empty});
idyn = ode(F,State,Control);
idyn.InitialCondition = [-200 0]';
idyn.Nt = 800;
idyn.FinalTime = 100;idyn.Solver = @ode23
%%
[tspan,Y] = solve(idyn,'Control',1*ones(idyn.Nt,idyn.ControlDimension))
animation(idyn,ax,Y)

%%
YT = [-20;-20];
Psi = (State-YT).'*(State-YT);
Psi = matlabFunction(Psi,'Vars',{t,State});
L   = 1e-1*(Control.'*Control);
L = matlabFunction(L,'Vars',{t,State,Control});

iP = Pontryagin(idyn,Psi,L);
%%
U0 = zeros(idyn.Nt,idyn.ControlDimension);
UOpt = GradientMethod(iP,U0,'Graphs',true,'DescentAlgorithm',@AdaptativeDescent);
YOpt = iP.Solution.Yhistory{end};
%%
GetSymCrossDerivatives(iP)
GetSymCrossDerivatives(iP.Dynamics)
%%
%solve(iP.Dynamics)
U =iP.Dynamics.Control.Numeric;
Y =iP.Dynamics.StateVector.Numeric;


  
YU0 = [Y U];
Udim = idyn.ControlDimension;
Ydim = idyn.StateDimension;

options = optimoptions('fmincon','display','iter',    ...
                       'MaxFunctionEvaluations',1e6,  ...
                       'SpecifyObjectiveGradient',true, ...
                       'CheckGradients',false,          ...
                       'SpecifyConstraintGradient',true, ...
                       'HessianFcn',@(YU,Lambda) Hessian(iP,YU,Lambda),'PlotFcn',{@optimplotx,@optimplotfval,@optimplotfirstorderopt});
%
funobj = @(YU) StateControl2DiscrFunctional(iP,YU(:,1:Ydim),YU(:,Ydim+1:end));

clear ConstraintDynamics
YU = fmincon(funobj,YU0, ...
           [],[], ...
           [],[], ...
           [],[], ...
           @(YU) ConstraintDynamics(iP,YU(:,1:Ydim),YU(:,Ydim+1:end)),    ...
           options);

iP.Dynamics.StateVector.Numeric = YU(:,1:Ydim);
iP.Dynamics.Control.Numeric = YU(:,Ydim+1:end);

YOpt = iP.Dynamics.StateVector.Numeric;
%%
animation(iP.Dynamics,ax,YOpt)

%%
%%

function animation(idyn,ax,Y)
it = 1;
if exist('l1')
    delete(l1)
end
l1 = line(Y(it,1),Y(it,2),'Parent',ax,'Color','red','Marker','o');
for it = 2:4:idyn.Nt
    l1.XData = Y(it,1);
    l1.YData = Y(it,2);
    pause(0.1)
end

end
