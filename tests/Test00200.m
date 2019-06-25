
X = sym('x',[2 1]);
U = sym('u',[1 1]);

F = @(t,X,U,Params) [   X(2)      ;  ...
                -X(2) + U ];
  
idyn = ode(F,X,U);
idyn.InitialCondition = [0 -1];

Psi = @(T,X) 0;
L   = @(t,X,U) X(1)^2 + X(2)^2 + 0.005*U^2;

iCP = Pontryagin(idyn,Psi,L);
U0 = zeros(idyn.Nt,idyn.ControlDimension);

GradientMethod(iCP,U0,'DescentAlgorithm',@ConjugateDescent,'Graphs',true)
JCG = iCP.Solution.Jhistory;
UCG = iCP.Solution.UOptimal;
GradientMethod(iCP,U0,'DescentAlgorithm',@AdaptativeDescent,'Graphs',true)
JSD = iCP.Solution.Jhistory;
USD = iCP.Solution.UOptimal;
