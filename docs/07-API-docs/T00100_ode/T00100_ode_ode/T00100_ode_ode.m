% ode is both a directory and a function.
% 
%   description:  The ode class is an object that will contain all the information 
%                to solve a differential equation. This can be the equation of the dynamics,
%                initial condition, or the solution method itself. This class is necessary in
%                order to generalize the optimal control methods used in other packages.
%   long: This class is the representation of an ode
%                 $$ \dot{Y} = f(t,Y,U) \ \  Y(0) = Y_0$$
%         where 
%             $$ Y = \begin{pmatrix} y_1 \\ y_2 \\..  \\ y_n  \end{pmatrix} \text{   ,   }
%                U  = \begin{pmatrix} u_1 \\ u_2 \\..  \\u_m   \end{pmatrix} $$
%         This class is necessary in the toolbox since within the toolbox to be able to systematize
%         some algorithms. You can create ode objects, which are capable of parameterizing so that 
%         with a solve statement it is solved. In this way, we can write the "solve" command within
%         our algorithms, without losing versatility in the solution of the equation. Let's see some
%         examples to make that clearer.
'hola'