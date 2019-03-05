
N = 7;

xline = linspace(-1,1,N)
Y0 = zeros(N,1);
Y0(floor(N/3):floor(2*N/3)) = 10;

A = FDLaplacian(N)

iode = ode('A',A)

iode.PDE = true;
iode.RKMethod = @ode45;
iode.FinalTime = 0.1;
iode.dt = 0.0001
iode.Condition = Y0;

solve(iode)
animation(iode,'YLim',[-0.5,10],'xx',0.05)

kode = ode('A',A)

kode.dt = 0.00001

Y0 = iode.VectorState.Numeric(end,:)
kode.Condition = Y0;
kode.Type = 'FinalCondition'
kode.FinalTime = 0.1;

solve(kode)
animation(kode,'YLim',[-0.5,10],'xx',0.05)