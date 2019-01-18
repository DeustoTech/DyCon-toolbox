%% 
% This work is regarding solving 1-d wave equation using RPS
% semi-discretization method and analysis corresponding dispersion relation
%%
% Solving 1-d wave equation with RPS semi-discretization method
% Considering 1-d wave equation,
%%
% 	$$ \begin{equation}
% 	\begin{cases}
% 	&u_{tt}- u_{xx} =0,  0\leq x\leq 1, t\in[0,T] \\
% 	& u(x,T)=u_0(x),\, \, 0\leq x\leq 1, \\
% 	& u_t(x,T)=u_1(x),\,\,0\leq x\leq 1,  \\
% 	& u(0,t)=u(1,t)=0, \,\, t\in[0,T],
% 	\end{cases}
% 	\label{wave}
% 	\end{equation} $$
%%
% 	When $(u_0,u_1) \in H_0^1(0,1)\times L^2(0,1)$, it admits a unique solution $u(x,t) \in C^0([0,T],H_0^1(0,1)) \cap C^1([0,T],L^2(0,1))$. 
% 	The energy of solution to \eqref{wave} $E(t)$ 
%%
% 	$$ \begin{equation}
% 	E(t)=\frac{1}{2}\int_{0}^{1} \vert u_x(x,t) \vert^2+ \vert u_t(x,t)\vert^2 dx,
% 	\end{equation} $$
%%
% 	is time conserved .
%% 
% With Hilbert Uniqueness Method, the exact controllability of \eqref{wave} is  equal to the observability of the adjoint \eqref{wave},
% Observability of \eqref{wave} reads as: Given $T\geq 2$, there exist a positive constant $C(T)\geq 0$ such that
%%
% $$ \begin{equation}
%       E(0)\leq C(T) \int_{0}^{T} \vert u_x(1,t) \vert ^2 dt.
% \end{equation} $$
%%
% holds for every solution $u(x,t)$ to adjoint system \eqref{wave}
%%
% RPS semi-discretization of  weak variation formulation  of \eqref{wave} is written as
%%
% 	$$ \begin{equation}
% 	M \frac{d^2 \boldsymbol{u}}{dt^2}=-R\boldsymbol{u},
% 	\label{fem_wave}
% 	\end{equation} $$ 
%%
% where $M_{i,j}:=\int_{-\infty}^{+\infty}\phi_i\phi_j dx$ and $R_{i,j}=\int_{-\infty}^{+\infty}\frac{d}{dx}\phi_i\frac{d}{dx}\phi_j dx $ and  the corresponding $\hat{A}(\omega)$ defined as
%%
% 	 $$ \begin{equation}
%       \hat{A}(\omega)= \frac{R e^{i\omega x_n}}{M e^{i\omega x_n} }.
% 	\end{equation} $$
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
clf
subplot(1,2,2);
plot(-1+h:h:1-h,log10(abs(Psi(:,16))));
subplot(1,2,1);
plot(-1:h:1,[0;Psi(:,16);0],'b');
%% 
% Set up the time interval, time step, source term $f=0$
T=1;J=10000;f=zeros(length(A),1);
%%
% Set up the concentration parameter of inital data $\gamma$, frequency $\xi$
% and generate fine grids $x$ and the initial data defined on them
gamma=H^(-1.8); xi=3/4*pi; x=-1+h:h:1-h; 
ui=exp(-gamma*(x).^2/2).*cos(xi*x/H);
uti=-gamma*(x).*exp(-gamma*(x).^2/2).*cos(xi*x/H)-xi/H.*exp(-gamma*(x).^2/2).*sin(xi*x/H);
%%  
% Solve the wave equation on fine mesh as a approximation of analytical
% solution, which will be used then as a reference of rps solution 
[u,ut] =  ODEsolver(M,L(2:end-1,2:end-1),ui,uti,f,T,J,M);
[X,Y]=meshgrid(-1+h:h:1-h,0:T/J:T);
clf, pcolor(X,Y,u') ;shading interp ; colorbar; 
title('finemesh solution')
%% 
% Solve the wave equation on coarsemesh using RPS method
xc=x(H/h*[1:Nbasis]);
Mc=Psi'*M*Psi; Lc=Psi'*L(2:end-1,2:end-1)*Psi;  
uci=exp(-gamma*(xc).^2/2).*cos(xi*xc/H);
utci=-gamma*(xc).*exp(-gamma*(xc).^2/2).*cos(xi*xc/H)-xi/H.*exp(-gamma*(xc).^2/2).*sin(xi*xc/H);
fc=zeros(length(Lc),1);
[uc,uct]=ODEsolver(Mc,Lc,uci,utci,fc,T,J,Mc);
clf, pcolor(X,Y,(Psi*uc)');shading interp ; colorbar; 
title('coarsemesh solution with rps basis')

%%
% Solve the wave equation on coarsemesh using p1 fem 
[uuc,uuct]=ODEsolver(MM,LL,uci,utci,fc,T,J,MM);
[XX,YY]=meshgrid(-1+H:H:1-H,0:T/J:T);
clf, pcolor(XX,YY,uuc'); shading interp ; colorbar; 
title('coarsemesh solution with linear basis')

%%
% *Plot the disperation relation of RPS-semi descretization*
%%
% RPS semi-discretization of  weak variation formulation  of \eqref{wave} is written as
%%
% $$ \begin{equation}
%    M \frac{d^2 \boldsymbol{u}}{dt^2}=-R\boldsymbol{u}
% \end{equation} $$

%%
% where $M_{i,j}:=\int_{-\infty}^{+\infty}\phi_i\phi_j dx$ and $R_{i,j}=\int_{-\infty}^{+\infty}\frac{d}{dx}\phi_i\frac{d}{dx}\phi_j dx $ and 
% the corresponding $\hat{A}(\omega)$ defined as
%%
% $$  \begin{equation}
% \hat{A}(\omega)= \frac{R e^{i\omega x_n}}{M e^{i\omega x_n} }.
% 	\end{equation} $$
%%
% Since there's no explicit formulation for matrix $M$ and $R$, We can
% only calculate the fourier symbol of $M$ and $R$ numerically. Assuming
% the matrix $M$ is symmetric and toplitze and dimension $N$ of $M$ being a odd number, then fourier symbol of $M$
%   could be written as
%%
% $$ \begin{equation}
% \hat{M}(\omega)= M_{(N+1)/2,(N+1)/2}-2\sum_{i=1}^{(N+1)/2-1}M_{(N+1)/2,i}cos(i\omega h ),\ \omega h = 0,\frac{1}{N+1}\pi,..., 2\pi.
% \end{equation} $$
%%
% For example, let $M$  be mass matrix corresponding p1
% finite element semi-descretization. the fourier symbol of $M$ is 
%%
% $$ \begin{equation}
% \hat{M}(\omega)=2/3+1/3cos(\omega h)
%  \end{equation} $$
%%
% Construct the discrete $cos(i\omega h)$ with $\omega h$ sampled at 1000
% points at interval $[0,2\pi]$
f = cell(N/2);
f{1} = @(x) 1;
for i =1:N/2-1
    f{i+1} = @(x)2*cos(i*x);
end
f = flip(f);

Matrix_cos=zeros(N/2,1000);
for i=1:N/2
    xx=linspace(0.1,2*pi,1000);
    Matrix_cos(i,:)=arrayfun(f{i},xx);
end
%%
% Calculate the fourier symbol of $M$ and $R$
M_symbol = 1/H*Mc(1/H,1:N/2)*Matrix_cos;
R_symbol = H*Lc(1/H,1:N/2)*Matrix_cos./xx.^2;
%%
% Plot the numerical phase velocity for sinusoidal solution and compare
% it with the ones for FDM and FEM
hold on 
phaseVelocity = R_symbol.^(1/2)./M_symbol.^(1/2);
clf, plot(xx,phaseVelocity)
% for p1 FEM
hold on 
p1PhaseV = sin(xx/2)./xx*2.*(2/3+1/3*cos(xx)).^(-1/2);
plot(xx,p1PhaseV)
% for FDM
hold on 
fdmPhaseV = sin(xx/2)./xx*2;
plot(xx,fdmPhaseV)
%
ax=gca; ax.XTick = ([ 0 1/2*pi 5/6*pi pi 2*pi]);
ax.XTickLabel =({'0','1/2\pi','5/6*\pi','\pi','2\pi'});
xlabel('\omega*H')
legend('RPS','P1 FEM','FDM')
%%
% Plot the numerical group velocity for sinusoidal solution and compare
% it with the ones for FDM and FEM
groupVelocity = diff(phaseVelocity)/((2*pi-0.1)/999).*xx(1:length(xx)-1)+phaseVelocity(1:length(xx)-1);
clf, plot(xx(1:length(groupVelocity)),groupVelocity)
% for p1 FEM
hold on 
p1GroupV = diff(p1PhaseV)/((2*pi-0.1)/999).*xx(1:length(xx)-1)+p1PhaseV(1:length(xx)-1);
plot(xx(1:length(xx)-1),p1GroupV)
% for FDM
hold on 
fdmGroupV = diff(fdmPhaseV)/((2*pi-0.1)/999).*xx(1:length(groupVelocity))+fdmPhaseV(1:length(groupVelocity));
plot(xx(1:length(groupVelocity)),fdmGroupV)
% for ecact group velocity
hold on 
plot(xx, ones(length(xx)),'LineStyle','--')
%
ax=gca; 
ax.XTick=([ 0 1/2*pi 5/6*pi pi 2*pi]);
ax.XTickLabel =({'0','1/2\pi','5/6*\pi','\pi','2\pi'});
ax.XLim=[0 pi];
xlabel('\omega*H')
legend('RPS','P1 FEM','FDM','exact')
%% 
% Plot the numerical disperation relation
% Disperation relation for RPS semi-discretizaton
diperss = phaseVelocity.*xx;
%%
clf
hold on
plot(xx,diperss)
% for P1 FEM
hold on, plot(xx,2*sin(xx/2).*(2/3+1/3*cos(xx)).^(-1/2));
% for FDM
hold on , plot(xx,2*sin(xx./2))
% for exact one
hold on , plot(xx,xx,'LineStyle','--')
ax=gca; 
ax.XTick=([ 0 1/2*pi 5/6*pi pi 2*pi]);
ax.XTickLabel =({'0','1/2\pi','5/6*\pi','\pi','2\pi'});
ax.XLim=[0 pi];
xlabel('\omega*H')
legend('RPS','P1 FEM','FDM','exact')
