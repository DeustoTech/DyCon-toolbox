%%
% DyCon Toolbox aims to group all the problems studied by the research team
% of the chair of mathematics. That is why it is necessary to create a common interface for
% you dissolve studied equations. To get an idea of the variety of equations involved
% we will name some:
%%
% - Heat Equation
%
% - Population Dynamics
%
% - Collective Behavior
%
% - Schrodinger Equation
%
% - Burgers Equation
%
% - Waves Equation
%% 
% Since these equations can be solved in different ways, we have opted to create
% a communication interface with external programs. All the equations that are defined
% in DyCon toolbox they will be represented by programming classes. So that the classes defined
% are compatible with the entire system must meet the following requirements.
%% 
% - They must have a property InitialCondition, which will be a vector double
%   of $[n \times 1]$  dimensions
%
% - They must have a tspan property, indicating the integration intervals. 
%   This must be a vector double  $[1 \times Nt]$ , where  Nt  is the number 
%   of points in time.
%
% - They must have a method 'solve', which resumes the dynamics for that initial 
%   condition and for that interval 'tspan', This method must accept an optional 
%   parameter 'Control', which allows solving the dynamics dependent on a function 
%   over time. This optional parameter must be an array of dimensions  $[m \times Nt]$, 
%   where  m  is the dimension of the control vector
%%
% These simple requirements allow to make conenxiones to other specialized programs 
% in the resolution of the different types of equations, previously mentioned. Dycon Toolbox
% has already implemented a general version to define ODEs. If we wanted to define the following ODE:
%%
% $$ \begin{bmatrix} \dot{y}_1 \\ \dot{y}_2 \end{bmatrix} = 
%    \left(\begin{array}{c} 
%                           u_{1}+\sin\left(y_{1}\,y_{2}\right)+y_{1}\,y_{2}\\  
%                           u_{2}+y_{2}+\cos\left(y_{1}\,y_{2}\right) 
%            \end{array}\right) $$
%%
% We could define as follows:
%%
% Symbolic State and Control Vectors
Y = sym('y',[2 1]); U = sym('u',[2 1]);
% Dynamics Definition
F = @(t,Y,U,Params) [ U(1) + sin(Y(1)*Y(2)) +   (Y(1)*Y(2))     ; ...
                      U(2) +      Y(2)      +  cos(Y(1)*Y(2)) ] ;

dynamics = ode(F,Y,U);
%%
% The class ** ode ** allows you to store all the information related to the dynamics, 
% and meets all requirements. If we look inside this function
dynamics
%%
% You can see the InitialCondition property. There is also the solver method that allows solving the dynamics.
[tspan,solution] = solve(dynamics);
%% 
% 