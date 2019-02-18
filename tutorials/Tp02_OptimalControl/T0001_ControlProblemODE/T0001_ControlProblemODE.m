%% 
% En DyCon toolbox se ha definido el problema de control optimo a traves de
% la minimizacion de un funcional. De esta forma podemos resolver problemas
% del tipo
%%
% $$ \min_{U \in \Omega } \Psi(t,Y(T)) + \int_0^T L(t,Y,U) dt $$
%%
% sujecto a 
%%
% $$ \dot{Y} = f(t,Y,U) $$
%% 
% Se ha creado una interfaz simbolica para la definición de la dinamica.
% Por ello que deberemos definir un vector simbolico $Y$, que representara
% el estado de la dinamica, ademas de una vector simbolico $U$ que
% representara el vector de control.
%% 
% Continuarémos con un ejemplo para simplificar.
%%
% Supongamos que queremos encontrar el control que minimiza el funcional:
%%
% $$ y_1^2 + y_2^2 + \int_0^2 u_1^2 + u_2^2 dt
%% 
% sujeto a 
%% 
% $$ \left( \begin{matrix}   
%       \dot{y_1} \\
%       \dot{y_2}
%     \end{matrix} \right)    =  
%     \left( \begin{matrix}   
%               y_2     \\ 
%               y_2                
%      \end{matrix} \right) $$
%% 
% Deberemos inicializar los vectores de control y de estado.
Y = sym('y',[2 1])
%%
U = sym('u',[1 1])
%%
% Una vez definidos podemos crear un vector simbolico con las misma
% dimensiones que el vector de estado. Este vector representara la dinamica
% del problema. Sigiendo la notacion utilizada al principio este vector
% será $f(t,Y,U)$
 F = [ Y(2)          ; ...
      -Y(2) + U(1) ] ;
%% 
% Utilizando el contructor de 'ode'
dynamics = ode(F,Y,U)
%%
% Esta es una objecto que representa la ecuacion diferencial
%% 
% mochos de los parámetros que definen la ecuacion han sido tomados por
% defecto. Espro ello que deberemos personalizarlo. Para que representa la
% dinamica que queramos. En este caso cambiaremos la condicion inicial y el
% intervalo en el tiempo
dynamics.Condition = [0;-1];
dynamics.dt = 0.01;
%%
% Un vez definido la dinamica podemos definir el funcional que minizaremos.
% Este funciona tendra que ser representado con las mismas variables con la
% que se ha definido la dinamica. Siguiendo la forma presentada en [1]
% deberemos definir las expresiones de $\Psi$ y $L$
Psi = sym(0);
L   = 0.005*(U.'*U) +  Y.'*Y ;
%%
% Ya habiendo creado la ecuacion diferencial y las expresiones para $\Psi$
% y $L$, podemos definir el problemas de control optimo de la siguiente
% manera:
iP = OptimalControl(dynamics,Psi,L);
%%
% Este contiene informacion que puede ser de ayuda para la resolucion del
% problema. Es importante notar que no estamos resolviendo el problema.
% Simplemente lo estamos definiendo. Los solvers seran metodos que
% actuan sobre este objeto.
iP
%% 
% Uno de estos solver es el Gradient method. Este simplemnte
% calcula un gradiente con ayuda de la condiciones de optimalidad de primer
% orden extraida del principio del minimo de pontryagin. Para resolver el
% problema con este método, simplemnte escribimos:
GradientMethod(iP)
%% 
% Gradient Method crea un solución para el problema. 
iP.solution
%%
% Gracias a que la estructura es unica independiente del solver, podemos
% implentar funciones de visualización para todos tipo de solver. Un
% ejemplo de esto es la funcion plot aplicado a los objetos OptimalControl
plot(iP)
