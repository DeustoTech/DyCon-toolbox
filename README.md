# DyCon Toolbox 
#### Documentation Page (https://deustotech.github.io/dycon-toolbox-documentation/)

For each of these objects, we create different methods for the resolution of problems. 

For each of these objects, we create different methods for problem resolution. In this way, we can easily choose the type of algorithm to solve the problem. For more information, continue exploring in our documentation.

#### Symbolic Interface
The symbolic interface of matlab makes the definition of problems easier. And in some cases, the problem can be solved analytically.

For example, DyCon Toolbox able to define a continuous state equations
```
x = sym('x',[4 1]);
u = sym('u',[4 1]);
F = @(t,x,u) x + u;
```
With the ode class, we can create a structure with all information for solve an initial condition problem
```
idynamics = ode(F,x,u);
```
#### Modular Structure
DyCon Toolbox has been designed to easily accept different blocks of code. In this way, you can use another solver of the differential equations or other optimizers in any one programming language and taking advantage of all the interface already created. The first addition of de DyCon Toolbox is the acopling with the PDE Toolbox, native of MATLAB. In this way, we can use the mesh tool of the matlab to define and solve the PDE equation, and sovle de optimal control problem with DyCon Toolbox.

#### Modular Structure
DyCon Toolbox has been designed to easily accept different blocks of code. In this way, you can use another solver of the differential equations or other optimizers in any one programming language and taking advantage of all the interface already created. The first addition of de DyCon Toolbox is the acopling with the PDE Toolbox, native of MATLAB. In this way, we can use the mesh tool of the matlab to define and solve the PDE equation, and sovle de optimal control problem with DyCon Toolbox.

#### Direct and Indirect Methods
Main feature of DyCon Toolbox are the severals methods. The optimal control problems can be solve via full discretization or via resolve the optimal conditions.

- Full Discretization (Direct Method)
- Optimal Conditions (Indirect Methods)

 
#### Tunnel to other platforms
DyCon Toolbox is able to create a optimal control problem. The syntaxis of DyCon toolbox is very general and can be translate to other solver. For example, we have a translation of a AMPL/Ipopt.
