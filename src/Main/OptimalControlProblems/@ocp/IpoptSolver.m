function [OptControl ,OptState] = IpoptSolver(iocp,ControlGuess,varargin)
%IPOPT Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
addRequired(p,'iocp')
addRequired(p,'ControlGuess')
addOptional(p,'StateGuess',[])

addOptional(p,'integrator','CrankNicolson',@(s) mustBeMember(s,{'BackwardEuler','ForwardEuler','rk4','rk5','CrankNicolson','rk8','SemiLinearBackwardEuler'}))

parse(p,iocp,ControlGuess,varargin{:})

integrator = p.Results.integrator;
StateGuess = p.Results.StateGuess;
%
opti = casadi.Opti();  % CasADi function


dyn = iocp.DynamicSystem; 
Nx =  dyn.StateDimension;
Nu =  dyn.ControlDimension;
Nt =  dyn.Nt;
f  =  dyn.DynamicFcn;
M  = dyn.MassMatrix;
%%
X = opti.variable(Nx,Nt); % state trajectory
U = opti.variable(Nu,Nt);   % control

tspan = dyn.tspan;

%% Functional
CFcn = iocp.CostFcn;
Cost = CFcn.FinalCostFcn(X(:,end)); 

L = {};
for k = 1:Nt
   L{k} = CFcn.PathCostFcn(tspan(k),X(:,k),U(:,k)) ;
end

L_t = CFcn.PathCostFcn(tspan,X,U);
result = sum(diff(tspan).*(L_t(2:end)+L_t(1:end-1))/2);

%%
opti.minimize(Cost + result) ; % minimizing L2 at the final time

%% Dynamic Constraint
% Initial Condition
opti.subject_to(X(:,1)==dyn.InitialCondition); % close the gaps

%% 
switch integrator
    case 'ForwardEuler'
        for k=2:Nt % loop over control intervals
           % Euler forward method
           dt = tspan(k) - tspan(k-1);
           x_next = X(:,k-1) + dt*f(tspan(k-1),X(:,k-1),U(:,k-1)); 
           opti.subject_to(X(:,k)==x_next); % close the gaps
        end

    case 'BackwardEuler'
        for k=2:Nt % loop over control intervals
           % Euler backward method
           dt = tspan(k) - tspan(k-1);
           x_next = X(:,k-1) + dt*(M\f(tspan(k),X(:,k),U(:,k))); 
           opti.subject_to(X(:,k)==x_next); % close the gaps
        end
    case 'CrankNicolson'
        for k=2:Nt % loop over control intervals
           % Euler backward method
           dt = tspan(k) - tspan(k-1);
           x_next = X(:,k-1) + 0.5*dt*f(tspan(k),X(:,k),U(:,k)) + 0.5*dt*f(tspan(k-1),X(:,k-1),U(:,k-1)); 
           opti.subject_to(X(:,k)==x_next); % close the gaps
        end        
    case 'rk4'
        for k=2:Nt % loop over control intervals
           % Euler forward method
           dt = tspan(k) - tspan(k-1);
           %
           k1 = f(tspan(k-1)         ,  X(:,k-1)              ,U(:,k-1));
           k2 = f(tspan(k-1)+0.5*dt  ,  X(:,k-1)+0.5*k1*dt    ,0.5*U(:,k-1)+0.5*U(:,k) );
           k3 = f(tspan(k-1)+0.5*dt  ,  X(:,k-1)+0.5*k2*dt    ,0.5*U(:,k-1)+0.5*U(:,k) );
           k4 = f(tspan(k-1)+1.0*dt  ,  X(:,k-1)+1.0*k3*dt    ,U(:,k));
           %
           x_next = X(:,k-1) + (1/6)*dt*(k1 + 2*k2 + 2*k3 + k4); 
           opti.subject_to(X(:,k)==x_next); % close the gaps
        end
    case 'rk5'

        for k=2:Nt % loop over control intervals
           % Euler forward method
           dt = tspan(k) - tspan(k-1);
           %
           k1 = f(tspan(k-1)         ,   X(:,k-1)                                   ,U(:,k-1));
           k2 = f(tspan(k-1)+0.25*dt  ,  X(:,k-1) + 0.250*k1*dt                     ,0.75*U(:,k-1)+0.25*U(:,k) );
           k3 = f(tspan(k-1)+0.25*dt  ,  X(:,k-1) + 0.125*k1*dt  + 0.125*k2*dt      ,0.75*U(:,k-1)+0.25*U(:,k) );
           k4 = f(tspan(k-1)+0.50*dt  ,  X(:,k-1) - 0.500*k2*dt  + 1.000*k3*dt      ,0.50*U(:,k-1)+0.50*U(:,k));
           k5 = f(tspan(k-1)+0.75*dt  ,  X(:,k-1) + (3/16)*k1*dt  + (9/16)*k4*dt    ,0.25*U(:,k-1)+0.75*U(:,k));
           k6 = f(tspan(k-1)+1.00*dt  ,  X(:,k-1) - (3/7 )*k1*dt  + (2/7)*k2*dt + (12/7)*k3*dt -(12/7)*k4*dt  + (8/7)*k5*dt ,U(:,k));

           %
           x_next = X(:,k-1) + (dt/90)*(7*k1+32*k3+12*k4+32*k5+7*k6); 
           opti.subject_to(X(:,k)==x_next); % close the gaps
        end
    case 'rk8'
        for k = 2:Nt
           dt = tspan(k) - tspan(k-1);
           t  = tspan(k-1);
           opti.subject_to(X(:,k) == rk8_step(f,t,X(:,k-1),dt,U(:,k-1),U(:,k)));
        end
    case 'SemiLinearBackwardEuler'
        A = dyn.A;
        B = dyn.B;
        %
        NLT = dyn.NonLinearTerm;%
        Ys  = dyn.State.sym;

        g = casadi.Function('g',{ts,Ys,Us},{NLT(ts,Ys(1),Us)./Ys(1)});

        %
        for k = 2:Nt
            dt = dyn.tspan(k) - dyn.tspan(k-1);
            C  = diag(1-dt*g(X(:,k-1))) - dt*A;
            yu = X(:,k-1)  + B*U(:,k-1);
            opti.subject_to(X(:,k) == C\yu);
        end
    
end

%% 

opti.set_initial(U, ControlGuess);
if isempty(StateGuess)
    StateGuess = zeros(Nx,Nt);
end
opti.set_initial(X, StateGuess);
%%
if ~isempty(iocp.constraints.MaxControlValue)
    opti.subject_to((U(:)) <  iocp.constraints.MaxControlValue)
end
if ~isempty(iocp.constraints.MinControlValue)
    opti.subject_to((U(:)) > iocp.constraints.MinControlValue)
end

opti.solver('ipopt'); % set numerical backend
tic
sol = opti.solve();   % actual solve
toc
OptState   = sol.value(X);
OptControl = sol.value(U);

end

