%% title: A Semidiscretization of the isothermal Euler equations
%% date: 2018-07-21
%% author: MichaelS

%% Introduction and mathematical model
% The aim is to model the gas transport through a pipeline network with compressor stations as controllable elements. Consider a connected,
% directed graph $G = (\mathcal{V}, \mathcal{E})$ with a set of nodes $\mathcal{V}$ ($\vert \mathcal{V} \vert = n$) and a set of edges
% $\mathcal{E}$ ($\vert \mathcal{E} \vert = m$). An edge $e$ can either be a flow edge ($e \in \mathcal{E}_F$ , $\vert \mathcal{E}_F \vert = m_1$)
% (pressure drop along the pipe caused by friction) or a compressor edge ($e \in \mathcal{E}_C$, $\vert \mathcal{E}_C \vert = m_2$) (pressure
% rise along the pipe caused by control). For notation, we define $f(e)$ as the feet of an edge and $h(e)$ as the head of an edge for all edges
% $e \in \mathcal{E}$. For one flow edge $e \in \mathcal{E}_F$ consider the isothermal Euler equations (see [@GugatUlbrich], [@GugatUlbrich2])
%%
% $$\label{eq:iso1} \textbf{(ISO)} \quad \left\{ \quad \begin{aligned}
% &{\frac{\partial}{\partial t}}p_e + a^2 {\frac{\partial}{\partial x}}q_e = 0 \\ 
% &{\frac{\partial}{\partial t}}q_e + {\frac{\partial}{\partial x}}\left( a^2 \frac{(q_e)^2}{p_e} + p_e \right) = -\frac{\lambda^F_e a^2}{2D_e} \frac{\vert q_e \vert q_e}{p_e}
% \end{aligned} \right.$$ 
%% 
% which model the gas flow through a single pipe.
% Here, $p_e = p_e(t,x)$ and $q_e = q_e(t,x)$ are pressure and flow, $D_e$
% is the (constant) diameter of pipe $e$, $a$ is the sound speed in the
% gas and $\lambda^F_e$ denotes the (constant) pipe friction coefficient.
% The Mach number $M_e$ is given by the quotient of velocity and sound
% speed, so it holds 
%%
% $$M_e = \frac{v_e}{a} = a \frac{q_e}{p_e}$$ 
%%
% The gas flow is called subsonic, if $0 < \vert v_e \vert < a$ (i.e.
% $\vert M_e \vert < 1$) and it is called supersonic, if
% $\vert v_e \vert > a$ (i.e. $\vert M_e \vert > 1$). We are only
% interested in subsonic solutions because this is the only relevant case
% for gas transportation in real world. For a compressor station, it must hold (see [@Gas-Modell:DomschkeHillerLangTischendorf2017]) 
%%
% $$\begin{aligned}
% \frac{c}{\gamma} \left( \left( \frac{p_e(t,L_e)}{p_e(t,0)} \right)^\gamma - 1 \right) = \tilde{u}_e(t).
% \end{aligned}$$ 
%%
%
% Here we have constants $c, \gamma$ and pressures
% $p_e(t,L_e)$ and $p_e(t,0)$ at the end and at the beginning of the edge.
% We assume that the flow through this edge is constant and we define
% $u(t) := \left( \frac{\gamma}{c} \tilde{u}_e(t) + 1 \right)^\frac{1}{\gamma}  $,
% so we can write the compressor properties for an edge
% $e \in \mathcal{E}_C$ as 
%%
% $$\label{compressorProperties} \begin{aligned}
% p_e(t,L_e) &= u(t)\ p_e(t,0), \\
% q_e(t,L_e) &= q_e(t,0).
% \end{aligned}$$ 
%% 
% Also we formulate some node conditions (boundary and
% coupling conditions) for the network. Motivated by real gas networks, we
% assume that for all input nodes $v \in \mathcal{V}_{\text{in}}$, a
% time-dependent pressure function $\underline{p}_e(t)$
% ($e \in \mathcal{E}$ s.t. $ f(e) \in \mathcal{V}_{\text{in}} $) is given
% and for all output nodes $v \in \mathcal{V}_{\text{out}}$, a flow
% function $\overline{b}_e(t)$ ($e \in \mathcal{E}$ s.t.
% $h(e) \in \mathcal{V}_{\text{out}}$) is given. For all inner nodes, we
% demand continuity in pressure and conservation of mass. We define the
% set $E_0(v)$ as all edges, that are connected to node $v$ and $E^+_0(v)$
% resp. $E^-_0(v)$ as all edges, that arrive at node $v$ resp. that leave
% node $v$. So it is 
%%
% $$\label{couplingConditions} \begin{aligned}
% p_e(t,L_e) &= p_f(t,0) \qquad \forall e \in E^+_0(v), f \in E^-_0(v), \\
% \sum_{ e \in E^+_0(v) } q_e(t,L_e) &= \sum_{ e \in E^-_0(v) } q_e(t,0).
% \end{aligned}$$ 
%%
% So our aim is to find time- and space-dependent
% functions $p_e$ and $q_e$ (for all $e \in \mathcal{E}$) such that for
% some space-dependent initial conditions $p_{e,0}$ and $q_{e,0}$ the
% equations (\[eq:iso1\]), (\[compressorProperties\]) and
% (\[couplingConditions\]) are fulfilled.\
%% The system in Riemann invariants
% Now, we reformulate the system using its Riemann invariants and we talk
% about existence and uniqueness of a solution. For every flow edge
% $e \in \mathcal{E}_F$ the eigenvalues of $A_e$ are given by
%%
% $$\begin{aligned}
% \lambda_{e,1} &= a^2 \frac{q_e}{p_e} + a = a(M_e+1), \\
% \lambda_{e,2} &= a^2 \frac{q_e}{p_e} - a = a(M_e-1)
% \end{aligned}$$ 
%%
% and the corresponding left eigenvectors are
%%
% $$\begin{aligned}
% l_{e,1} &= \frac{1}{p_e} \left[ +a ,\ (1-a\frac{q_e}{p_e} \right] = \frac{1}{p_e} \left[ +a ,\ (1-M_e) \right], \\
% l_{e,2} &= \frac{1}{p_e} \left[ -a ,\ (1+a\frac{q_e}{p_e} \right] = \frac{1}{p_e} \left[ -a ,\ (1+M_e) \right]
% \end{aligned}.$$ 
%%
% Multiplying the PDE in with the left eigenvectors, on
% get the Riemann invariants 
%% 
% $$\begin{aligned}
% &r_{e,1}(t,x,p_e(t,x),q_e(t,x))\ =\ \ln(p_e) + a \frac{q_e}{p_e}\ =\ \ln(p_e) + M_e \\
% \text{and} \quad &r_{e,2}(t,x,p_e(t,x),q_e(t,x))\ =\ \ln(p_e) - a \frac{q_e}{p_e}\ =\ \ln(p_e) - M_e.
% \end{aligned}$$ 
% We set $R_e(t,x,\Psi_e(t,x)) := [r_{e,1}(t,x,p_e(t,x),q_e(t,x)),\ r_{e,2}(t,x,p_e(t,x),q_e(t,x)) ]^T$.
% So (\[eq:iso1\]) is equivalent to 
%% 
% $$\label{eq:iso2} \begin{aligned}
% {\frac{\partial}{\partial t}}R_e(t,x) + \begin{bmatrix} \lambda_{e,1}(t,x,R(t,x)) & 0 \\ 0 & \lambda_{e,2}(t,x,R(t,x)) \end{bmatrix} {\frac{\partial}{\partial x}}R_e(t,x) = F_e(t,x,R_e(t,x)).
% \end{aligned}$$ 
%% 
% For further analysis, we will omit writing the explicit
% dependence on $(p_e(t,x),q_e(t,x))$. Next we write the compressor
% property and the node conditions in terms of Riemann invariants.
% Therefor we assume that every compressor edge $e_C \in \mathcal{E}_C$ is
% locally linear in the graph, that means there exists exactly one edge
% $e \in \mathcal{E}$ with $h(e) = f(e_C)$ and there also exists exactly
% one edge $\tilde{e} \in \mathcal{E}$ with $f(\tilde{e}) = h(e_C)$. This
% is a weak assumption on the graph and it implies that
% $f(e_C) \notin \mathcal{V}_{\text{in}}$ and
% $h(e_C) \notin \mathcal{V}_{\text{out}}$. So we can write the compressor
% properties as 
%%
% $$\begin{aligned} 
% &p_{e+1}(t,0) = u_e(t) p_{e-1}(t,L_e) \\
% \text{and} \quad &q_{e+1}(t,0) = q_{e-1}(t,L_e),
% \end{aligned}$$ 
%%
% where $e-1$ and $e+1$ are the unique edges connected to
% $f(e)$ and $h(e)$ for all $e \in \mathcal{E}_C$. One can interpret this
% step as a removal of the compressor edges from the graph, but its
% properties must still hold. So we can only look for a solution on the
% flow edges meeting the compressor properties. Now, we write the
% compressor properties in terms of Riemann invariants:
%%
% $$\label{eq:compressorProperties} \begin{aligned}
% (r_{e+1,1} + r_{e+1,2})(t,0) &= 2 \ln(u_e(t)) + (r_{e-1,1} + r_{e-1,2})(t,L_{e-1}), \\
% u_e(t) (r_{e+1,1} - r_{e+1,2})(t,0) &= (r_{e-1,1} - r_{e-1,2})(t,L_{e-1}).
% \end{aligned} \quad \forall e \in \mathcal{E}_C$$ 
%% 
% We also write the coupling conditions in terms of Riemann invariants:
%%
% $$\label{eq:nodeConditions} \begin{aligned}
% (r_{e,1} + r_{e,2})(t,L_e) &= (r_{\tilde{e},1} + r_{\tilde{e},2})(t,0) \qquad \forall e,\tilde{e} \in \mathcal{E} \text{ s.t. } h(e) = f(\tilde{e}), \\
% \sum_{ \{ e \in \mathcal{E} \vert h(e) = v \} }  (r_{e,1} - r_{e,2})(t,L_e) &= 
% \sum_{ \{ e \in \mathcal{E} \vert f(e) = v \} } (r_{e,1} - r_{e,2})(t,0) \quad \forall v \in \mathcal{V}_{\text{in}}.
% \end{aligned}$$ 
%%
% For the boundary conditions we have
%%
% $$\label{eq:boundaryConditions} \begin{aligned}
% (r_{e,1} + r_{e,2})(t,0) &= 2 \ln(\underline{p}_e(t)) \qquad \forall e \in \mathcal{E} \text{ s.t. } f(e) \in \mathcal{V}_{\text{in}}, \\
% (r_{e,1} - r_{e,2})(t,L_e) \exp\left( \frac{(r_{e,1} + r_{e,2})(t,L_e)}{2} \right) &= 2 \overline{b}(t) \qquad \forall e \in \mathcal{E} \text{ s.t. } h(e) \in \mathcal{V}_{\text{out}}.
% \end{aligned}$$
%% 
% So our model is now
%%
% $$\text{(\textbf{RSYS})} \quad \left\{ \begin{aligned}
% &{\frac{\partial}{\partial t}}R_e(t,x) + \Lambda_e(t,x,R(t,x)) {\frac{\partial}{\partial x}}R_e(t,x) = F_e(t,x,R_e(t,x)) \quad \forall e \in \mathcal{E}_F \\
% &\text{s.t. } (\ref{eq:compressorProperties}), (\ref{eq:nodeConditions}), (\ref{eq:boundaryConditions}) \text{ are fulfilled} \\
% &\text{and } R_e(0,x) = R_{e,0}(x) 
% \end{aligned} \right.$$ 
%%
% So our aim now is to find Riemann invariants
% $r_{e,1}(t,x)$, $r_{e,2}(t,x)$ for all $e \in \mathcal{E}_F$, s.t.
% (**RSYS**) is fulfilled. In [@GugatUlbrich], *Theorem 5.1*, the authors
% give a general well posedness result for systems like ours. With this,
% the pressure and the flow can be computed the following:
%%
% $$\begin{aligned}
% p_e(t,x) &= \exp\left( \frac{(r_{e,1} + r_{e,2})(t,x)}{2} \right), \\
% q_e(t,x) &= \frac{(r_{e,1}-r_{e,2})(t,x)}{2a} \exp\left( \frac{(r_{e,1} + r_{e,2})(t,x)}{2} \right).
% \end{aligned}$$
 
%% Semidiscretization of the system
% In a next step, we discretize (**RSYS**) in space using a finite
% differences scheme. We can assume w.l.o.g. that every flow edge in the
% graph has the same length $L$. We separate the space interval $[0,L]$ in
% $n+1$ uniformly distributed points $x_i$ with $x_1 = 0$, $x_{n+1} = L$
% and $\Delta x = x_{k+1} - x_k = L/n$ for all $k = 1, \cdots, n$.\
% For all $i = 2, \cdots, n$ we approximate the space derivative at $x_i$
% using a central difference quotient. For the upper and lower point, we
% use a left and a right difference quotient. So the finite differences
% matrix $D \in \mathbb{R}^{2(n+1) \times 2(n+1)}$ is a block diagonal
% matrix with block diagonal $\frac{1}{2\Delta x}(\tilde{D}, \tilde{D})$
% and 
%% 
% $$\tilde{D} = \begin{bmatrix}
% -2 & 2  & 0      & 0  & \cdots &    & 0 \\
% -1 & 0  & 1      & 0  &        &    &   \\
% 0  & -1 & 0      & 1  &        &    &   \\
% \vdots & &\ddots & \ddots & \ddots & & \vdots   \\
%    &    &        & -1 & 0      & 1  & 0 \\
%    &    &        & 0  & -1     & 0  & 1 \\
% 0  &    & \cdots & 0  & 0      & -2 & 2
% \end{bmatrix}.$$ 
%% 
% For notation, we introduce a third index to the Riemann
% invariants, such that $r_{e,i,j}(t) = r_{e,i}(t,x_j)$ for
% $e \in \mathcal{E}_F$, $i \in \{1,2\}$ and $j \in \{1, \cdots, n+1\}$.
% For all $t \in [0,R]$ we define time-dependent vectors
% $r_{e,i}^D(t) \in \mathbb{R}^{n+1}$ as vectors of all space discretized
% Riemann invariants, evaluated at the grid points, and we set
% $R^D_e(t) := [r^D_{e,1}(t), r^D_{e,2}(t)]^T$. We also add the third
% index to the function on the right, such that
% $F_{e,i,j}(t,R^D_e(t)) = F_{e,i}(t,x_j,R(t,x_j))$, we define time
% dependent vectors $F^D_{e,i}(t,R^D_e(t)) \in \mathbb{R}^{n+1}$ for the
% right hand side corresponding to the time-dependent Riemann vectors
% $r^D_{e,i}(t)$ and we set
% $F^D_e(t,R^D_e(t)) = [F^D_{e,1}(t,R^D_e(t)), F^D_{e,2}(t,R^D_e(t))]^T$.
% Let $\Lambda^D_e$ be the discretized matrix of eigenvalues of edge $e$.
% The next step is to insert the boundary- and node conditions. If the
% initial conditions meet these boundary- and node conditions, it is
% sufficient inserting the time-derivatives of them. Because of this step,
% the mass matrix is not the identity anymore. We?ll give an example for
% that later.\
% For solving this semi-discretized problem for a given finite time $T$,
% we choose a equidistant partition of the time interval. We use a
% *Crank-Nicolson-Method* to solve the time-dependent problem. For a
% general time-dependent problem $\dot{y} = f(y)$ that means we do not
% directly compute $y^{n+1}$ using
%%
% $$y^{n+1} = y^n + \Delta t f(y^n) \quad \text{or} \quad y^{n+1} = y^n + \Delta t f(y^{n+1}),$$
%%
% which is the explicit resp. implicit Euler method, we use a auxiliary
% variable $y^\theta = \theta y^{n+1} + (1-\theta) y^n$ for a
% $\theta \in [0,1]$ which we use for evaluating $f$. We improve this
% value as long as possible to get a solution for the next time step. If
% we choose $\theta = 0$ this is equivalent to the explicit Euler method
% and for $\theta = 1$ it is equivalent to the implicit Euler method. In
% our problem, for better stability of the scheme, we insert the formula
% for $y^\theta$ in the linear parts and we use $y^\theta$ for evaluating
% the nonlinear parts. This leads to
%%
% $$M \frac{(R^D_e)^{n+1} - (R^D_e)^n}{\Delta t} + \Lambda^D_e D \left( \theta (R^D_e)^{n+1} + (1-\theta)(R^D_e)^n \right) = F^D_e((R^D_e)^\theta),$$
% which is equivalent solving
%%
% $$(M + \Delta t \theta \Lambda^D_e D ) (R^D_e)^{n+1} = (M - \Delta t (1-\theta) \Lambda^D_e D) (R^D_e)^n + \Delta t F^D_e((R^D_e)^{\theta}).$$
%%
% We formulate an algorithm for the computation. The exponential index is
% for the time step.\
% 
%% A minimal example
% Now we want to illustrate the results using a minimal example. Consider
% therefor the minimal linear graph $G = (\mathcal{V}, \mathcal{E})$ with
% four nodes, two flow edges and one compressor edge: 
%%
% $$\begin{aligned} 
% \mathcal{V} &= \{0,1,2,3\}, \\ 
% \mathcal{E}_F &= \{e_1, e_2\} = \{(0,1),(2,3)\}, \\
% \text{and} \quad \mathcal{E}_C &= \{e_C\} = \{(1,2)\}.
% \end{aligned}$$ 
%%
% With the boundary conditions described before, the graph
% is the following:
% 
% \[htbp\] \[fig:graph\]
% 
% \(A) at (0,0) \[circle, draw\] [$0$]{}; (B) at (3,0) \[circle, draw\]
% [$1$]{}; (C) at (6,0) \[circle, draw\] [$2$]{}; (D) at (9,0) \[circle,
% draw\] [$3$]{};
% 
% \(A) to node\[above\] [$e_1 \in \mathcal{E}_F$]{} (B); (B) to
% node\[above\] [$e_c \in \mathcal{E}_C$]{} (C); (C) to node\[above\]
% [$e_2 \in \mathcal{E}_F$]{} (D);
% 
% (-1,0) to node\[above\] [$\underline{p}(t)$]{} (A); (D) to node\[above\]
% [$\overline{b}(t)$]{} (10,0);
% 
% The Riemann invariants for both edges are given by 
%%
% $$\begin{aligned}
% r_{1,1}(t,x)\ &=\ \ln(p_1) + a \frac{q_1}{p_1}\ =\ \ln(p_1) + M_1, \\
% r_{1,2}(t,x)\ &=\ \ln(p_1) - a \frac{q_1}{p_1}\ =\ \ln(p_1) - M_1, \\
% r_{2,1}(t,x)\ &=\ \ln(p_2) + a \frac{q_2}{p_2}\ =\ \ln(p_2) + M_2, \\
% r_{2,2}(t,x)\ &=\ \ln(p_2) - a \frac{q_2}{p_2}\ =\ \ln(p_2) - M_2.
% \end{aligned}$$ 
%%
% Removing the compressor edges, like described before,
% the node conditions get redundant here. The system written in Riemann
% invariants, using $R_1(t,x) = [r_{1,1}(t,x), r_{1,2}(t,x)]^T$,
% $R_2(t,x) = [r_{2,1}(t,x), r_{2,2}(t,x)]^T$,
% $R(t,x) = [R_1(t,x), R_2(t,x)]^T$ and
% $\tilde{\Lambda}(R(t,x)) \in \mathbb{R}^{4 \times 4}$ with
% diag$\tilde{\Lambda}(R(t,x)) = (\Lambda_1(R_1(t,x)), \Lambda_2(R_2(t,x)))$,
% is then 
%%
% $$\label{ex:RSYS} (\textbf{RSYS}) \quad \left\{ \begin{aligned}
% &{\frac{\partial}{\partial t}}R(t,x) + \tilde{\Lambda}(R(t,x)) {\frac{\partial}{\partial x}}R(t,x) = F(R(t,x)) \\
% &\left. \begin{aligned} 
% &(r_{2,1} + r_{2,2})(t,0) = 2 \ln(u_{e_C}) + (r_{1,1} + r_{1,2})(t,L) \\
% &u(t)(r_{2,1} - r_{2,2})(t,0) = (r_{1,1} - r_{1,2})(t,L) \\
% \end{aligned} \hspace{1.56cm} \right\} &\text{compressor properties} \\
% &\left. \begin{aligned}
% &(r_{1,1} + r_{1,2})(t,0) = 2 \ln(\underline{p}(t)) \\
% &(r_{2,1} + r_{2,2})(t,L) + 2\ln( (r_{2,1} - r_{2,2})(t,L)) = 2 \ln(2a\overline{b}(t))
% \end{aligned} \quad \right\} &\text{boundary conditions} \\
% &\left. \begin{aligned}
% R_1(0,x) = \underline{R}_1(x) \\
% R_2(0,x) = \underline{R}_2(x)
% \end{aligned} \hspace{6.33cm} \right\} &\text{initial conditions}
% \end{aligned} \right.$$
%%
% with initial conditions $\underline{R}_1(x)$,
% $\underline{R}_2(x)$. We remove the compressor edge from the graph and
% use the space-discretization described before. For inserting the
% boundary conditions we use the representation
%%
% $$\label{ex:boundaryConditions} \begin{aligned}
% r_{1,1,1}(t) &= 2 \ln( \underline{p}(t) ) - r_{1,2,1}(t) &\text{lower boundary} \\
% r_{2,2,n+1}(t) &= 2 \text{W}\left( -a \overline{b}(t) \exp(-r_{2,1,n+1}(t)) \right) + r_{2,1,n+1}(t) \quad \quad &\text{upper boundary}
% \end{aligned}$$
%%
% and for inserting the compressor properties, we use the
% representation 
%%
% $$\begin{aligned}
% r_{1,2,n+1}(t) &= \frac{(1-u(t))r_{1,1,n+1}(t) + 2u(t)r_{2,2,1}(t) - 2u(t)\ln(u(t))}{(u(t)+1)}, \\
% r_{2,1,1}(t) &= \frac{(1-u(t))r_{1,1,n+1}(t) + 2u(t)r_{2,2,1}(t) - 2u(t)\ln(u(t))}{(u(t)+1)}.
% \end{aligned}$$ 
%% 
% The following pictures show the results of
% implementation for constant boundary data.
% 
% ![image](./images/ConstantBoundaryTime0.png){width="7cm"}\
% ![image](./images/ConstantBoundaryTime2.png){width="7cm"}
% 
% ![image](./images/ConstantBoundaryTime1.png){width="7cm"}\
% ![image](./images/ConstantBoundaryTime10.png){width="7cm"}
% 
% So what one can observe in this results is, that the dynamic solution
% converges to the stationary solution, if a $C^0$ compatibility condition
% for the initial and the boundary condition is fulfilled. Also one can
% see that there is a discontinuity in pressure, which is because of the
% compressor station. As demanded, the flow is continuous. The stationary
% solution was computed with a classical Newton method.\
%% Outlook
% This work should be a basis of analyzing a long time behavior of
% controlling the isothermal Euler equations. The aim is to observe
% turnpike properties in optimal control problems related to the
% isothermal Euler equations.
