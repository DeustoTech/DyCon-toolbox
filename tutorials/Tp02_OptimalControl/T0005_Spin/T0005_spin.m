%% 
% In this tutorial we will see how to use the implementation for optimal control in the DyCon Toolbox,
% for this it is necessary to define some notations. Since the optimal control is defined as an optimization 
% problem with a constraint, the differential equation. We will follow the notation used in the article Pontryagin
% Maximum Principle
clear;
%%
% The vectors
%%
% $$ symY = \left( \begin{matrix}   y1 \\
%                                   y2 
%                  \end{matrix} \right) $$
%%
% $$ symU = \left( \begin{matrix}   u1 \\
%                                   u2 
%                   \end{matrix} \right) $$
%%
% We will use symbolic variables to define them.
syms t
symY = SymsVector('y',4);
symU = SymsVector('u',4);
%%
% *Ordinary differential equation*
%%
% In this case we will define the following differential equation
% %%
% % $$ \dot{\textbf{Y}} = \left( \begin{matrix} 
% %   -1  &  1 \\
% %    0  & -2 \\
% %   \end{matrix} \right) * \textbf{Y} + 
% %   \left( \begin{matrix} 
% %    1  &  0 \\
% %    0  &  1 \\
% %   \end{matrix} \right) * \textbf{U} 
% % $$ 
% Y0 = [  0; ...
%        +1 ];
% %
% A = [ -1  1  ;  ...
%        0 -2 ];
% %  
% B = [  1 0; ...
%        0 1 ];
%%
Y0 = [2,3.2,1,4];

Fsym  = symU;
%%
% To do this, we create an object differential equation. We can do it with the ODE constructor, in the following way.
T = 8;
odeEqn = ode(Fsym,symY,symU,'Condition',Y0,'FinalTime',T)

%%
%� *Cost Functional* 
%%
% $$ J = \Psi(Y(T),t) + \int_0^T L(Y(t,U),U(t),t) dt$$
% %%
% % For this, we choose a target of vector state  
% YT = [ 1; ... 
%        4];
%%
% Then, 
% %%
% % $$\Psi(Y,t) = \vert Y(T) - Y(t) \vert^2 $$
% symPsi  = (YT - symY).'*(YT - symY);
%%
% and 
%%
% $$ L(Y(t,U),U(t),t) = \beta \vert U(t)\vert^2$$
beta=1;
alphaone=0.0392; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_1".
alphatwo=24.5172; %in the pdf "draft_Marposs3.pdf", this parameter is "\alpha_2".

symPsi  = sym(0);
symL    = (0.5)*(symU(1)^2+symU(2)^2+symU(3)^2+symU(4)^2)+(0.5)*(beta*alphaone)*((-(sin(symY(1))+sin(symY(2))+sin(symY(3))+sin(symY(4))))^2+(cos(symY(1))+cos(symY(2))+cos(symY(3))+cos(symY(4)))^2)+(0.5)*((beta*alphatwo)*((sin(symY(4))+sin(symY(3))-sin(symY(2))-sin(symY(1)))^2+(cos(symY(1))+cos(symY(2))-cos(symY(3))-cos(symY(4)))^2));
%% 
% For last, you an create the functional object

%% 
% Creta the control Problem
iCP1 = OptimalControl(odeEqn,symPsi,symL);

%%
% Solve Gradient
%GradientMethod(iCP1,'Graphs',true,'DescentAlgorithm',@ClassicalDescent,'DescentParameters',{'LengthStep',1e-4})
GradientMethod(iCP1,'Graphs',true,'DescentAlgorithm',@AdaptativeDescent,'MaxIter',40000)

%%
% ![](extra-data/081472.gif)
%%
% We solve the equation without control
solve(odeEqn) 
% 
figure
plot(odeEqn.tline',odeEqn.Y(:,1),'Color','red')
line(odeEqn.tline',odeEqn.Y(:,2),'Color','green')
legend({'Y_1','Y_2'})
%% 
% The solution obtained in the gradient method is:
odec = iCP1.ode;
figure
plot(odec.tline',odec.Y(:,1),'Color','red')
line(odec.tline',odec.Y(:,2),'Color','green')
legend({'Y_1','Y_2'})