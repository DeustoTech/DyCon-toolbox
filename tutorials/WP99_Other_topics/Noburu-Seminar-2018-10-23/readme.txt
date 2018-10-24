InvertedPend_model.m: 
Creates equations of motion using Lagrange's method. Matrices A and B are obtained at the end as numeric matrices.

InvertedPend_model2.m: 
Creates nonlinear model as text data so that you can define equations for nonlinear simulations. You can skip this file if you directly edit the output of "Nsys" in InvertedPend_model.m. 

InvertedPend_control.m:
Does simulations for linear and nonlinear models. 

InvertedPend_dric.m: 
Solves finite-interval optimal control problem solving a differential Riccati equation. This has to be run after InvertedPend_model.m. No need to run InvertedPend_model2.m. At the end this script compares the responses with controllers by algebraic and differential Riccati equations. 

f_dric.m
Solves differential Riccati equations in the form of \dot{P} = PA + A'P - PRP +Q. Notice that the sign is different from the standard theory. 


