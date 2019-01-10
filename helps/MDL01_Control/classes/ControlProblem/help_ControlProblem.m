%% 
% First define the vectors
%%
% $$ symY = \left( \begin{matrix}   y1 \\
%                                   y2 
%                  \end{matrix} \right)
%    symU = \left( \begin{matrix}   u1 \\
%                                   u2 
%                   \end{matrix} \right) $$
%%
clear;
syms t
symY = SymsVector('y',2);
symU = SymsVector('u',1);
%%
% *Cost Functional*
%%
% $$ J = \Psi(Y(T),t) + \int_0^T L(Y(t,U),U(t),t) dt$$
A = 10;
symPsi  = 0;
symL    = A*(symU.'*symU) + symY(2);
%%
Jfun = Functional(symPsi,symL,symY,symU);
%%
% *Ordinary differential equation*
%%
% In this case we will define the following differential equation
%%
% $$ \left( \begin{matrix}   \dot{S} \\
%                            \dot{I} 
%                  \end{matrix} \right)
%    = 
%       \left( \begin{matrix}   \lambda - \beta S I - \sigma_1 S \\
%                               \beta S I - u_1 I - \sigma_2 I
%                   \end{matrix} \right) $$
Lambda = 1;beta = 0.5;
sigma1 = 0.1;sigma2 = 0.1;

S = symY(1);I = symY(2);
Fsym(1)  = Lambda - beta*S*I -  sigma1*S; 
Fsym(2)  = beta*S*I - symU(1)*I - sigma2*I ;
%
Fsym = Fsym.'
%%
T = 20;
S0 = 100 ;I0 = 15;
Y0 = [ S0 ; I0];
odeEqn = ode(Fsym,symY,symU,'Y0',Y0,'T',T);
%%
% Now, We can create the control problem
iCP1 = ControlProblem(odeEqn,Jfun);
%%
% and solve by Classical Gradient Method
DescentParameters = {'MiddleStepControl',true,'InitialLengthStep',1e-5,'MinLengthStep',1e-10};
Gradient_Parameters = {'maxiter',50,'DescentParameters',DescentParameters};
%
GradientMethod(iCP1,Gradient_Parameters{:})
%%
plot(iCP1)

