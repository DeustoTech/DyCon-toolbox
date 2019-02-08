%%
% Veamos un ejemplo de utilizacion de la clase ode. Para ello resolveremos
% un ejemplo sencillo. Sea la ode:
%%
% $$ \begin{bmatrix}
% \dot{y}_1 \\
% \dot{y}_2
% \end{bmatrix} = \left(\begin{array}{c} u_{1}+\sin\left(y_{1}\,y_{2}\right)+y_{1}\,y_{2}\\ u_{2}+y_{2}+\cos\left(y_{1}\,y_{2}\right) \end{array}\right)
% $$
%%
% $$ y_1(1) = 1 / / y_2(1) = -1 $$
%%
% En Dycon Toolbox se opta por el uso de variables simbólicas para
% representación de las ecuaciones de la dinamica. Es por ello que es
% necesario definir un vector simbolico que representara el estado 

Y = sym('y',[2 1])
%%
% Además deberemos definir un vector simbolico para el control de la
% ecuacion
U = sym('u',[2 1])
%%
% Gracias a estas dos variables, podemos definir la ecuación de la dinamica
% de la siguietne forma
F = [ sin(Y(1)*Y(2)) +    (Y(1)*Y(2)) + U(1)   ; ...
         Y(2)        + cos(Y(1)*Y(2)) + U(2) ] ;
dynamics = ode(F,Y,U);
%%
% Debemos notar que el la creacion del problema es muy parecido a la
% expresion matematica
%% 
% Veamos que es lo que hemos creado 
dynamics
%%
% Debido a que existe mucha infomacion para resolver una ecuacion
% diferencial DyCon toolbox toma muchos valores por defecto. Otra forma de
% ver la información dentro de este objecto es:
resume(dynamics)
%%
% Por otro lado, que existan muchos parametros por defecto, esto no quiere
% decir que
dynamics.Condition = [1,-1];
%%
solve(dynamics)
plot(dynamics)
%%
dynamics.Type = 'InitialCondition';
solve(dynamics,'RKMethod',@ode23)
plot(dynamics)
%% 
% Lineal
A = [ -1 0 ; 0 -1];
B = [1 ; 1];

lode = ode('A',A,'B',B)
solve(lode)
plot(lode)