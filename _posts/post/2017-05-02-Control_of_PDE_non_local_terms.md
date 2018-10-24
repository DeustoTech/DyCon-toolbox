---
layout: post
categories: Posts
title: Control of PDEs involving non-local terms
author: [UmbertoB, EnriqueZ]
tags:
subtitle:
bibliography: biblio.bib
---
## Why non-local?

Relevant models in Continuum Mechanics, Mathematical Physics and Biology are of non-local nature:
- Boltzmann equations in gas dynamics;
- Navier-Stokes equations in Fluid Mechanics;
- Keller-Segel model for Chemotaxis.

Moreover, these models are applied for the description of several complex phenomena for which a local approach is inappropriate or limiting.
- Peierls-Nabarro equation in elasticity (\cite{elasticity});
- Image processing algorithms (\cite{image_proc});
- Anomalous diffusion models (\cite{anomalous});
- Finance: description of the pricing of American options (\cite{finance}).

In this setting, classical PDE theory fails because of non-locality. Yet many of the existing techniques can be tuned and adapted, although this is often a delicate matter.

## Fractional time derivatives

We analyze the problem of controllability of fractional (in time) Partial Differential Equations. In contrast with the classical PDE control theory, when driving these systems to rest, one is required not only to control the value of the state at the final time but also the memory accumulated by the long-tail effects that the fractional derivative introduces.
As a consequence, the notion of null controllability to equilibrium needs to take into account both the state and the memory term.

In particular, in \cite{time_frac_eq} we consider the full controllability problem for the system

$$
	\left\{\begin{array}{ll}
		\partial_{t,0+}^{\alpha}\,y-Ay=Bu,& t\in(0,+\infty)
		\\
		y(0)=y_0
	\end{array}\right.
$$

with $A$ and $B$ two linear unbound operators and where $\partial_{t,0+}^{\alpha}$ is a classical Caputo derivative. We show that, due to the memory effects controllability cannot be achieved in finite time.  

## Fractional Schrödinger and wave equations

In \cite{frac_schr}, we analyse evolution problems involving the fractional Laplace operator $(-\Delta)^s$, $s\in(0,1)$, on a bounded $C^{1,1}$ domain $\Omega\subset\mathbb{R}^N$. In particular we consider the fractional Schrödinger equation

$$ 
	iu_t+(-\Delta)^su=0, \;\;(x,t)\in\Omega\times(0,T)
$$

and the fractional wave equation

$$
	u_{tt}+(-\Delta)^{2s}u=0, \;\; (x,t)\in\Omega\times(0,T).
$$

Our main goal is to study the controllability of this kind of phenomena.
- **Fractional Schrödinger equation**: we assume Dirichlet homogeneous boundary conditions and we prove null controllability provided $s\geq 1/2$ and that the control is active on a neighborhood $\omega$ of a subset of the boundary fulfilling the classical multiplier conditions. Moreover, in the limit case $s=1/2$, controllability holds only if the control time $T$ is large enough.
- **Fractional wave equation**: we obtain analogous controllability properties, as a direct consequence of the results for the Schrödinger equation.

These mentioned controllability properties may be studied also through the employment of microlocal analysis techniques. In this framework, in [] we present a WKB expansion for the fractional Schrödinger equaiton in one space dimension, which allows to show that the solutions of the model propagate following the rays of geometric optics and that their controllability properties may be reinterpreted in terms of the velocity of propagation of this mentioned rays.

## Viscoelasticity

Viscoelastic materials are those for which the behaviour combines liquid-like and solid-like characteristic (\cite{visco}).

![image](./visco_car.png)
![](./visco_ball.png)
![](./visco_bed.png) 

In \cite{moving}, we consider the following model of viscoelasticity, given by a wave equation with both a viscous Kelvin-Voigt and frictional damping

$$
	y_{tt}-\Delta y-\Delta y_t+b(x)y_t=h\chi_{\omega(t)},
$$

in which we incorporate an internal control $h$ with a moving support. Our analysis is based on the fact that the above equation can be rewritten as a system coupling a parabolic equation with an ODE. The presence of this ODE, in the case of a fixed  support of the control, is responsible for the lack of controllability of the system, due to the absence of propagation in the space-like direction. Therefore, we prove the null controllability when the control region, driven by the flow of an ODE, covers all the domain.

## Equations with non-local spatial terms

In [], we study the null controllability of the following linear heat equation with spatial non-local integral terms:

$$
	y_t-\Delta_y+\int_{\Omega} K(x,\xi)y(\xi,t)\,d\xi=v\chi_{\omega}.
$$

Under some analyticity assumptions on the corresponding kernel, we show that the equations is controllable. We employ compactness-uniqueness arguments in a suitable functional setting, an argument that is harder to apply for heat equations because of its very strong time irreversibility.

These mentioned results have been later improved in [], where we adopted a Carleman approach which allowed us to remove the (strong) analitycity assumptions on the kernel, and to replace them with sharp exponential decay conditions at the extrema of the time domain considered.

## Models with memory terms

In \cite{memory}, we approach the control problem for the following heat equation with lower order memory

$$
	y_t-\Delta y+ \int_0^t y(s)\,ds=u\chi_{\omega}(x).
$$

This can be rewritten as a system coupling a heat equation with an ordinary differential equation, as in the context of viscoelasticity. In view of this structure we introduce a Moving geometric Control Condition (MGCC), which turns out to be sufficient for moving control. Furthermore, in \cite{memory_wave} we obtain similar results for the following wave equation with a lower order memory term

$$
	y_{tt}-\Delta y + \int_0^t y(s)\,ds=u\chi_{\omega},
$$

while in [] we were able to address the case of the following one-dimensional wave equation with memory in the principal part

$$
	y_{tt}-y_{xx} + M\int_0^t y_{xx}(s)\,ds=u\chi_{\omega}(x),
$$
## Perspectives
- Weakening the MGCC for the control of viscoelasticity models.
- Models with fractional time derivatives: what kind of control theoretical properties can be expected once exact controllability is excluded?
- General analytic memory kernels.
- Geometric Optics for wave-like models involving the fractional Laplacian.
- Can Carleman inequalities handle non-local terms?
- Links with delay systems.
- Nonlinear models.

## References
