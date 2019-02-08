clear;
%%
syms t
symY = SymsVector('y',4);
symU = SymsVector('u',4);
%%

%% Dynamics 
T = 8;
Y0 = [2,3.2,1,4];
Fsym  = symU;

dynamics = ode(Fsym,symY,symU,'Condition',Y0,'FinalTime',T);
%
beta=1;
alphaone=0.0392; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_1".
alphatwo=24.5172; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_2".

symPsi  = sym(0);
symL    = (0.5)*(symU(1)^2+symU(2)^2+symU(3)^2+symU(4)^2)+ ...
          (0.5)*(beta*alphaone)*((-(sin(symY(1))+sin(symY(2))+sin(symY(3))+sin(symY(4))))^2  + ...
                                   (cos(symY(1))+cos(symY(2))+cos(symY(3))+cos(symY(4)) )^2) + ...
          (0.5)*(beta*alphatwo)*(  (sin(symY(4))+sin(symY(3))-sin(symY(2))-sin(symY(1)) )^2   + ...
                                   (cos(symY(1))+cos(symY(2))-cos(symY(3))-cos(symY(4)) )^2);
%% 
% For last, you an create the functional object
%% 
% Creta the control Problem
iCP1 = OptimalControl(dynamics,symPsi,symL);
%% Solve Gradient
%GradientMethod(iCP1,'Graphs',true,'DescentAlgorithm',@ClassicalDescent,'DescentParameters',{'LengthStep',1e-1})

GradientMethod(iCP1,'Graphs',true,'DescentAlgorithm',@ConjugateGradientDescent,'MaxIter',40000,'tol',1e-8)
%%
