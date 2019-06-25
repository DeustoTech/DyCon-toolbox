clear;
%%
syms t
symY = SymsVector('y',4);
symU = SymsVector('u',4);
%%

%% Dynamics 
T = 120;
Y0 = [2,3.2,1,4].';
Fsym  = @(t,Y,U,Params) U;

dynamics = ode(Fsym,symY,symU,'InitialCondition',Y0,'FinalTime',T);
dynamics.Solver =  @eulere;
dynamics.Nt = 100;
%dynamics.SolverParameters = {odeset('RelTol',1e-1,'AbsTol',1e-1)};


%
beta=1;
alphaone=0.0392; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_1".
alphatwo=24.5172; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_2".

symPsi  = @(T,Y) 0;
symL    = @(t,Y,U) (U(1)^2+U(2)^2+U(3)^2+U(4)^2)+ ...
          (0.5)*(beta*alphaone)*((-(sin(Y(1))+sin(Y(2))+sin(Y(3))+sin(Y(4))))^2  + ...
                                   (cos(Y(1))+cos(Y(2))+cos(Y(3))+cos(Y(4)) )^2) + ...
          (0.5)*(beta*alphatwo)*(  (sin(Y(4))+sin(Y(3))-sin(Y(2))-sin(Y(1)) )^2   + ...
                                   (cos(Y(1))+cos(Y(2))-cos(Y(3))-cos(Y(4)) )^2);
%% 
% For last, you an create the functional object
%% 
% Creta the control Problem
iCP1 = Pontryagin(dynamics,symPsi,symL);
%% Solve Gradient
U0 = zeros(length(dynamics.tspan),dynamics.ControlDimension);
GradientMethod(iCP1,U0,'Graphs',false,'DescentAlgorithm',@AdaptativeDescent,'display','all','MaxIter',300,'EachIter',50,'Graphs',false)
%%
U0 = iCP1.Solution.UOptimal;
GradientMethod(iCP1,U0,'Graphs',false,'DescentAlgorithm',@ConjugateDescent,'display','all','tol',1e-3,'MaxIter',100,'EachIter',10,'Graphs',false)
%
%options = optimoptions('fminunc','display','iter','SpecifyObjectiveGradient',true,'Algorithm','quasi-newton','CheckGradients',false)
%UOpt = fminunc(@(U) Control2Functional(iCP1,U),U0,options)

%%
U = iCP1.Dynamics.Control.Numeric;
Y = iCP1.Dynamics.StateVector.Numeric;

GetSymCrossDerivatives(iCP1)

GetSymCrossDerivatives(iCP1.Dynamics)
  
YU = [Y U];
Udim = dynamics.ControlDimension;
Ydim = dynamics.StateDimension;

options = optimoptions('fmincon','display','iter',    ...
                       'MaxFunctionEvaluations',1e6,  ...
                       'SpecifyObjectiveGradient',true, ...
                       'CheckGradients',false,          ...
                       'SpecifyConstraintGradient',true)%  , ...
                       %'HessianFcn',@(YU,Lambda) Hessian(iCP1,YU,Lambda));
%
funobj = @(YU) StateControl2DiscrFunctional(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end));
fmincon(funobj,YU, ...
           [],[], ...
           [],[], ...
           [],[], ...
           @(YU) ConstraintDynamics(iCP1,YU(:,1:Ydim),YU(:,Ydim+1:end)),    ...
           options)


%%
error('sd')
%%
close all
subplot(1,2,1)
plot(iCP1.Dynamics.Control.Numeric,'.-')
subplot(1,2,2)
plot(iCP1.Dynamics.StateVector.Numeric,'.-')