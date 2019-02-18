%%
% En este tutorial mostraremos las tipos de descenso implementados para el metodos del gradiente para los 
% problemas de control optimos
%%
% Primero definiremos un problema para utilizarolo de ejemplo
%%
% Sea el siguiente funcional
%% 
% dollars-dollars \int_0^2 (y_1-2)^2 + (y_2-4)^2 + u_1^2 + u_2^2 dt
%%
% sujecto a
%% 
% dollars-dollars \left( \begin{matrix}   
%       \dot{y_1} \\
%       \dot{y_2}
%     \end{matrix} \right)    =  
%     \left( \begin{matrix}   
%               y_2     \\ 
%               y_2                
%      \end{matrix} \right) dollars-dollars
%%
% Creamos el objeto Optimal Control
Y = sym('y',[2 1]); U = sym('u',[1 1]);
%%
% define dynamics
 F = [ Y(2)             ; ...
      -Y(2)      + U(1) ] ;
% 
dynamics = ode(F,Y,U);
dynamics.Condition = [0;-1];
dynamics.dt = 0.01;
%%
YT = [2;4];
Psi = sym(0);
L   =0.005*(U.'*U) +  (Y-YT).'*(Y-YT) ;
% Creace de OptimalControl Object 
iP = OptimalControl(dynamics,Psi,L);
%%
% GradientMethod ha sido definido como un metodo iterativo que actualiza
% el control dada un control anterior. Esta actualización pretende mejorar
% el valor de dollarsJ(u)dollars mediante un descenso del gradiente. Sin embargo se
% permite distintos tipos de descenso. Esta implementados tres tipos de
% descenso 
% - ConjugateGradientDescent: Se actuliza siguiendo el método de gradiente
%                             conjugado, porpuesto en [1]
% - ClassicalDescent: Se calcula el gradiente, dollarsdJdollars dado un control y se
%                       actualiza el control de la siguiente forma:
%                       dollarsu_{new} =  u_{old} + \alpha dJdollars. Siendo dollars\alphadollars
%                       una constante que puede ser modificada
% - AdaptativeDescent: Se actualiza el control de la misma forma que en
%                       ClassicalDescent, sim embargo el parámetro \alpha se multiplica por dos
%                       si el valor de J decrece, y se divide por dos si el valor de J crece. De
%                       esta forma, tenemos valores de dollars\alphadollars grande cuando el descenso nos lo
%                       permite, y valores de dollarsalphadollars, mas finos si estamos cerca de un mínimo
% local.

% Solve 
GradientMethod(iP)
plot(iP)
%%
GradientMethod(iP,'DescentAlgorithm',@ClassicalDescent)

% Solve by Conjugate Gradient
% http://web.mit.edu/mitter/www/publications/2_conjugate_grad_IEEEAC.pdf 

% 
GradientMethod(iP)
plot(iP)
plot(iP)
% Is more fast