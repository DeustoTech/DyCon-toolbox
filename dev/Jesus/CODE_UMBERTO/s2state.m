%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Controllability of the fractional heat equation                %%%%%%%
%%%%                                                                %%%%%%% 
%%%% u_t + (-d_x^2)^s u = f, (x,t) in (-1,1)x(0,T)                  %%%%%%%
%%%% u=0,                    (x,t) in [R\(-1,1)]x(0,T)              %%%%%%% 
%%%% u(0)=u_0,                x in (-1,1)                           %%%%%%%
%%%%                                                                %%%%%%%                      
%%%% using finite element and the penalized HUM                     %%%%%%%   
%%%% U. Biccari, V. Hernández-Santamaría, July 2017                 %%%%%%%
%%%% Heavily based on F. Boyer's work                               %%%%%%% 
%%%% v. 0.0                                                         %%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function soly = s2state(s)

donnees = struct('tolerance', 1.0000e-03);    
%%

Nx = 150;

%%
xline = linspace(-1,1,Nx+2);
xline = xline(2:end-1);
dx    = xline(2) - xline(1);

epsilon = dx^4;


A = -FEFractionalLaplacian(s,1,Nx);
B = BInterior(xline,-0.3,0.5,'Mass',true);

idyn    = pde('A',A,'B',B);
idyn.FinalTime  = 0.5;
idyn.Nt = 150;
idyn.mesh{1} = xline;
idyn.MassMatrix = MassMatrix(xline);

y0 = sin(pi*xline');
idyn.InitialCondition = y0;

adjoint    = pde('A',A);
adjoint.FinalTime  = 0.5;
adjoint.Nt = 150;
adjoint.mesh{1} = xline;
adjoint.MassMatrix = MassMatrix(xline);


f0 = 0*xline';
tol = 1e-2

target = 0*xline';
fOpt =grad_conj(idyn,adjoint,epsilon,tol,f0,target);


adjoint.InitialCondition = fOpt;
[~ ,solphi] =solve(adjoint);
solphi = flipud(solphi);
        
        
idyn.InitialCondition = y0;
[~ ,soly] = solve(idyn,'Control',(idyn.B*solphi')');
    
        
controle=(idyn.B*solphi')';


    

%%
figure 
surf(controle)
figure
surf(soly)