%% 
% This work is regarding solving 1-d wave equation using RPS
% semi-discretization method and analysis corresponding dispersion relation.
%%
% Considering adjoint system of \eqref{wave}.
%%
% 	$$
% 	\begin{equation}\begin{cases}
% 	&u_{tt}- u_{xx} =0,  0\leq x\leq 1, t\in[0,T] \\
% 	& u(x,T)=u_0(x),\, \, 0\leq x\leq 1, \\
% 	& u_t(x,T)=u_1(x),\,\,0\leq x\leq 1,  \\
% 	& u(0,t)=u(1,t)=0, \,\, t\in[0,T],
% 	\end{cases}
% 	\label{wave}\end{equation}
% 	$$
%%
% 	When $(u_0,u_1) \in H_0^1(0,1)\times L^2(0,1)$, it admits a unique solution 
%%
% $$ u(x,t) \in C^0([0,T],H_0^1(0,1)) \cap C^1([0,T],L^2(0,1)) $$ 
%%
% The energy of solution to \eqref{wave} $E(t)$ 
%%
% $$ E(t)=\frac{1}{2}\int_{0}^{1}|u_x(x,t)|^2+|u_t(x,t)|^2 dx $$
%%
% is time conserved .
%% 
% With Hilbert Uniqueness Method, the exact controllability of \eqref{control} is  equal to the observability of the adjoint \eqref{wave},
% Observability of \eqref{wave} reads as: Given $T\geq 2$, there exist a positive constant $C(T)\geq 0$ such that
%%
% 	$$ E(0)\leq C(T) \int_{0}^{T} |u_x(1,t)|^2 dt $$
%%
% holds for every solution $u(x,t)$ to adjoint system \eqref{wave} RPS semi-discretization of  weak variation formulation  of \eqref{wave} is written as
%%
% $$ \begin{equation}
% M \frac{d^2 \boldsymbol{u}}{dt^2}=-R\boldsymbol{u}
% \label{fem_wave}
% \end{equation} $$
%%
% 	where $M_{i,j}:=\int_{-\infty}^{+\infty}\phi_i\phi_j dx$ and $R_{i,j}=\int_{-\infty}^{+\infty}\frac{d}{dx}\phi_i\frac{d}{dx}\phi_j dx $ and  the corresponding $\hat{A}(\omega)$ defined as
%%
% 	$$
% 	\hat{A}(\omega)= \frac{R e^{i\omega x_n}}{M e^{i\omega x_n} }.
% 	$$
%%
% As for this problem, the rps basis $\phi_i(x)$ corresponding  $x_i$ is defined by 
%%
% 	$$ \begin{equation}
% 	\phi_i =\left\{
% 	\begin{aligned}
% 	\arg &\min_{v \in H_0^2[-1,1]}  \int_{-1}^{1}(\frac{d^2}{dx^2} v)^2 dx  \\
% 	&s.t.\  v(x_j) = \delta_{i,j},\ \ j = \{1,...,N\}, \\
% 	\end{aligned}
% 	\right.
% 	\label{basis}
% 	\end{equation} $$
%%
% Set up uniform fine mesh and coarse mesh
h = 2^(-8); H=2^(-4); Nbasis=2/H-1;
n = 2/h; N=2/H;
%%
% Construct the stiffness matrix and massive matrix regarding p1 finite
% element on fine mesh and coarse mesh respectively
L = sparse([1:n+1,1:n,2:n+1],[1:n+1,2:n+1,1:n],[2*ones(1,n+1),-ones(1,2*n)]);
LL= sparse([1:N-1,1:N-2,2:N-1],[1:N-1,2:N-1,1:N-2],[2*ones(1,N-1),-ones(1,2*N-4)]);
M = sparse([1:n-1,1:n-2,2:n-1],[1:n-1,2:n-1,1:n-2],[2/3*h*ones(1,n-1),1/6*h*ones(1,2*n-4)]);
MM = sparse([1:N-1,1:N-2,2:N-1],[1:N-1,2:N-1,1:N-2],[2/3*H*ones(1,N-1),1/6*H*ones(1,2*N-4)]);
L=1/h*L;
LL=1/H*LL;
%%
% Construct the discrete energy $\|-div(a\nabla \cdot)\|$
temp = L(:,2:end-1);
boundary = L([1,end],2:end-1);
A = temp'*temp+100*(boundary')*boundary;
%%
% Matrix corresponding  pointwise constrains
B = eye(n-1,n-1);
B = B(H/h*[1:Nbasis],:);
%%
% Solve the rps basis by solving the optimization problems 
Psi = zeros(n-1,Nbasis);
for i = 1:size(B,1)
    ei = zeros(Nbasis,1); 
    ei(i,1) = 1;
    Psi(:,i) = A\(B'*((B*inv(A)*B')\ei));
end
%%
% plot the basis and log scale of basis
figure
subplot(1,2,2);
plot(-1+h:h:1-h,log10(abs(Psi(:,30))));
subplot(1,2,1);
plot(-1:h:1,[0;Psi(:,30);0],'b');

%% 
% Set up the time interval, time step, source term $f=0$
T=5;J=10000;f=zeros(length(A),1);
%%
% Set up the concentration parameter of inital data $\gamma$, frequency $\xi$
% and generate fine grids $x$ and the initial data defined on them
gamma=H^(-2); xi=5/6*pi; x=-1+h:h:1-h; 
ui=exp(-gamma*(x).^2/2).*cos(xi*x/H);
uti=-gamma*(x).*exp(-gamma*(x).^2/2).*cos(xi*x/H)-xi/H.*exp(-gamma*(x).^2/2).*sin(xi*x/H);
%%  
% Solve the wave equation on fine mesh as a approximation of analytical
% solution, which will be used then as a reference of rps solution 
[u,ut] =  ODEsolver(M,L(2:end-1,2:end-1),ui,uti,f,T,J,M);
[X,Y]=meshgrid(-1+h:h:1-h,0:T/J:T);
%%
figure, pcolor(X,Y,u') ;shading interp;
colorbar; 
title('finemesh solution')
%% 
% Solve the wave equation on coarsemesh using RPS method
xc=x(H/h*[1:Nbasis]);
Mc=Psi'*M*Psi; Lc=Psi'*L(2:end-1,2:end-1)*Psi;  
uci=exp(-gamma*(xc).^2/2).*cos(xi*xc/H);
utci=-gamma*(xc).*exp(-gamma*(xc).^2/2).*cos(xi*xc/H)-xi/H.*exp(-gamma*(xc).^2/2).*sin(xi*xc/H);
fc=zeros(length(Lc),1);
[uc,uct]=ODEsolver(Mc,Lc,uci,utci,fc,T,J,Mc);
%% 
figure, pcolor(X,Y,(Psi*uc)');shading interp; 
colorbar; 
title('coarsemesh solution with rps basis')

%%
% Solve the wave equation on coarsemesh using p1 fem 
[uuc,uuct]=ODEsolver(MM,LL,uci,utci,fc,T,J,MM);
[XX,YY]=meshgrid(-1+H:H:1-H,0:T/J:T);
%%
figure, pcolor(XX,YY,uuc'); shading interp;
colorbar; 
title('coarsemesh solution with linear basis')

