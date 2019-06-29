param L:= 8;
param Nx :=50;   # intervalle en x: [0,L]
param dx := L/Nx;
param Nt := 200;
param c := 0.33;
param eps default 1;
param tf=30;
param dt = tf/Nt;

var y {i in 0..Nt, j in 0..Nx};  # y(t,x)
var ul {i in 0..Nt} >=0, <=1; #, default 0;


minimize cost: sum {j in 1..Nx} ((y[Nt,j]-c)*(y[Nt,j]-c));


var dyn {i in 0..Nt-1, j in 0..Nx} = (1-y[i,j])*(y[i,j]-c);

subject to pde_y {i in 0..Nt-1, j in 1..Nx-1}:
  (dx^2)*y[i+1,j]*(1-dt*min(0,dyn[i,j])) = (dx^2)*(1+dt*max(0,dyn[i,j]))*y[i,j]  + dt*(y[i+1,j+1]-2*y[i+1,j]+y[i+1,j-1]);

subject to left_boundary  {i in 1..Nt-1}: y[i,0] = ul[i];
subject to right_boundary {i in 1..Nt-1}: y[i,Nx]= ul[i];

subject to y_init {j in 0..Nx}: y[0,j]  = 0.99;


option solver ipopt;
option ipopt_options "max_iter=8000 linear_solver=mumps halt_on_ampl_error yes";
solve;


printf: " # cost = %24.16e\n", cost; # > out4.txt;
printf: " # tf = %24.16e\n", tf; # >> out4.txt;
printf: " # Nx = %d\n", Nx; # >> out4.txt;
printf: " # Nt = %d\n", Nt; # >> out4.txt;
printf: " # Data\n"; # >> out4.txt;
printf {i in 0..Nt-1}: " %24.16e\n", ul[i]; # >> out4.txt;
printf {i in 0..Nt, j in 0..Nx}: " %24.16e\n", y[i,j]; # >> out4.txt;

end;