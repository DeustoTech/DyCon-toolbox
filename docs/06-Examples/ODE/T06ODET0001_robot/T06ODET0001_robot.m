clear
syms x1 x2 theta nu1 nu2 omega t

syms u1 u2 


alpha = 0.2;


dynamics = [ nu1;   ...
             nu2;   ...
             omega; ...
             (u1 + u2)*cos(theta); ...
             (u1 + u2)*sin(theta); ...
             alpha*(u1-u2)];
         
         
 
 
 Y = [x1; x2; theta; nu1; nu2; omega];
 U = [u1; u2];

Params = sym.empty;
dynFcn = matlabFunction(dynamics,'Vars',{t,Y,U,Params});
iode = ode(dynFcn,Y,U);
iode.InitialCondition = [-10;-10;0.5*pi;0;0;0];
iode.FinalTime = 12;
iode.Solver = @eulere;
iode.Nt = 100;

YT = [0;0;0;0;0;0];

delta = 1;
gamma = 1;
Psi = @(t,Y)0.5*delta*(Y-YT).'*(Y-YT);
L   = @(t,Y,U) gamma*(abs(U(1)) + abs(U(2)));
%L   = gamma*((u1)^2 + u2^2);

iCP = Pontryagin(iode,Psi,L);

U0 = iode.Control.Numeric;
options = optimoptions(@fminunc,'display','iter','SpecifyObjectiveGradient',true);
fminunc(@(U)Control2Functional(iCP,U),U0,options)

%iCP.constraints.Umax = 0.2;
%iCP.constraints.Umin = -0.2;


GradientMethod(iCP,U0,'Graphs',false,'DescentAlgorithm',@AdaptativeDescent,'display','functional')