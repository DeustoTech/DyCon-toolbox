clear;
%%
syms t
symY = SymsVector('y',4);
symU = SymsVector('u',4);
%%

%% Dynamics 
T = 8;
Y0 = [2,3.2,1,4]';
Fsym  = @(t,Y,U) U;

dynamics = ode(Fsym,symY,symU,'InitialCondition',Y0,'FinalTime',T);
dynamics.Solver =  @eulere;
dynamics.Nt = 100;
%
beta=1;
alphaone=0.0392; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_1".
alphatwo=24.5172; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_2".

symPsi  = @(T,Y) 0;
symL    = @(t,Y,U) (0.5)*(U(1)^2+U(2)^2+U(3)^2+U(4)^2)+ ...
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
GradientMethod(iCP1,U0,'Graphs',false,'DescentAlgorithm',@AdaptativeDescent,'display','all')
U0 = iCP1.Solution.UOptimal;
GradientMethod(iCP1,U0,'Graphs',false,'DescentAlgorithm',@ConjugateDescent,'display','all','tol',1e-5)

%%
close all
subplot(1,2,1)
plot(iCP1.Dynamics.Control.Numeric,'.-')
subplot(1,2,2)
plot(iCP1.Dynamics.StateVector.Numeric,'.-')
