%%

t2_guess = 10;
[t2,fval] = fmincon(@Y_cost,t2_guess,[],[],[],[],1,14);

%%

Y = sym('y',[8 1]); % States vectors for positions and velocities
ud = Y(1:2); ue = Y(3:4); vd = Y(5:6); ve = Y(7:8);

U = sym('u',[1 1]);
kappa = U(1); % Control function of the original problem

ur = ud-ue; % Relative position, driver - evader

f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);
nu_e = 2.0;
nu_d = 2.0;

% Dynamics
dot_ud = vd;
dot_ue = ve;
dot_vd = -f_d2(ur.'*ur)*ur - nu_d*vd + kappa * [-ur(2);ur(1)];
dot_ve = -f_e2(ur.'*ur)*ur - nu_e*ve;

F = [dot_ud;dot_ue;dot_vd;dot_ve];
t = sym('t');
F = matlabFunction(F,'Vars',{t,Y,U,sym.empty});

dt = 0.01; % Numerical time discretization
dynamics = ode(F,Y,U,'FinalTime',14,'Nt',100);

% ud = (-3,0), ue = (0,0), and zero velocities initially.
dynamics.InitialCondition = [-3;0;0;0;0;0;0;0]; 
tline = dynamics.tspan;

U0_tline = [1*(tline<=(t2)).*(tline>=(2))]'; 
uf = [-1;1];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dynamics.Solver=@ode45;
dynamics.SolverParameters={options};

% Trajectories from initial guess
% Test the initial guess on the control, 'U0_tline'.
solve(dynamics);

Y_tline = dynamics.StateVector.Numeric;
figure();
hold on
plot(Y_tline(:,1),Y_tline(:,2),'b-');
plot(Y_tline(:,3),Y_tline(:,4),'r-');
plot(uf(1),uf(2),'ks','MarkerSize',20)


j=1;
plot(Y_tline(j,1),Y_tline(j,2),'bs');
plot(Y_tline(j,3),Y_tline(j,4),'rs');

plot(Y_tline(end,1),Y_tline(end,2),'bo');
plot(Y_tline(end,3),Y_tline(end,4),'ro');
hold off
legend('Driver','Evader','Location','northwest')
xlabel('abscissa')
ylabel('ordinate')

%%

Y_cost(9.96);

function cost = Y_cost(t2_guess)

Y = sym('y',[8 1]); % States vectors for positions and velocities
ud = Y(1:2); ue = Y(3:4); vd = Y(5:6); ve = Y(7:8);

U = sym('u',[1 1]);
kappa = U(1); % Control function of the original problem

ur = ud-ue; % Relative position, driver - evader

f_e2 = @(x) (2./x);
f_d2 = @(x) -(-5.5./x+10./x.^2-2);
nu_e = 2.0;
nu_d = 2.0;

% Dynamics
dot_ud = vd;
dot_ue = ve;
dot_vd = -f_d2(ur.'*ur)*ur - nu_d*vd + kappa * [-ur(2);ur(1)];
dot_ve = -f_e2(ur.'*ur)*ur - nu_e*ve;
t = sym('t')
F = [dot_ud;dot_ue;dot_vd;dot_ve];
F = matlabFunction(F,'Vars',{t,Y,U,sym.empty});
dt = 0.01; % Numerical time discretization
dynamics = ode(F,Y,U,'FinalTime',14,'Nt',100);

% ud = (-3,0), ue = (0,0), and zero velocities initially.
dynamics.InitialCondition = [-3;0;0;0;0;0;0;0]; 
tline = dynamics.tspan;

U0_tline = [1*(tline<=(t2_guess)).*(tline>=(2))]'; 
uf = [-1;1];

dynamics.Control.Numeric = U0_tline;
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
dynamics.Solver=@ode23;
dynamics.SolverParameters={options};

% Trajectories from initial guess
% Test the initial guess on the control, 'U0_tline'.
solve(dynamics);

Y_tline = dynamics.StateVector.Numeric;


Y_fun = @(t) interp1(tline,Y_tline(:,3:4),t);
tf_guess = 13;

[t_f,fval] = fmincon(@(t) ((Y_fun(t)-uf')*(Y_fun(t)-uf')'),tf_guess,[],[],[],[],0,14);

cost = fval

end