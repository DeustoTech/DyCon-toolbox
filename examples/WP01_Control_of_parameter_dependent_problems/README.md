# Control of parameter dependent problems (PDC)
In real applications, models are not completely known since relevant parameters (deterministic or stochastic) are subject to uncertainty and indetermination. Accordingly, for practical purposes, robust analytical and computational methods are needed, allowing to control not only a given realization of the model but also to deal with parameter-dependent families of systems in a stable, robust and computationally efficient way.

This issue requires the development of specific new analytical and numerical tools and constitutes one of our major objectives. We mainly focus on the deterministic setting, although our techniques can also be adapted to stochastic and random models.

Averaged control is a first important concept that aims to control the averaged dynamics. This is often a challenging issue since the model governing the evolution of the averaged dynamics is usually hard to be determined and may change type with respect to the original parameter-depending dynamics. Furthermore, in some practical applications, averaged control turns out to be insufficient since it does not guarantee to control the variance of the states. New techniques are needed to guarantee the efficient control of the system for all the realizations of the parameter values.

We aim to adapt the existing techniques of reduced modelling and nonlinear approximation by exploiting the notion of sparsity, in order to build optimal methods (with respect to the computational cost and complexity) for controlling parameter-dependent PDEs in a robust manner. To this end, we rely on the use of greedy and weak-greedy algorithms to identify the most meaningful realizations of the parameters and L^1 minimisation to search for impulsional controls.

For doing this we view the parameter-dependent family of controls and controlled solutions as a manifold in the product control/state space.

These techniques are applied and tested in some classical benchmark control problems for parabolic and hyperbolic PDEs, but can also be adapted to more challenging problems as the optimal location of controllers and actuators.