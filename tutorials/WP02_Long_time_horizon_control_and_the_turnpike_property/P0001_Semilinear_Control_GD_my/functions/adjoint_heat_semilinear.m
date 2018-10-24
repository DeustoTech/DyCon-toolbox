function [ p ] = adjoint_heat_semilinear( state, T, source )
% We solve the adjoint problem
% \begin{equation*}
% \begin{cases}
% -p_t- p_{xx}+3y^2p=g\hspace{2.8 cm} & \mbox{in} \hspace{0.10 cm}(0,T)\times (0,1)\\
% p(t,0)=p(t,1)=0  & \mbox{on}\hspace{0.10 cm} (0,T)\\
% p(T,x)=0  & \mbox{in}\hspace{0.10 cm}  (0,1).
% \end{cases}
% \end{equation*}
% We first solve
% \begin{equation*}
% \begin{cases}
% \varphi_t -\varphi_{xx}+3(y(T-t))^2\varphi=g(T-t)\hspace{2.8 cm} & \mbox{in} \hspace{0.10 cm}(0,T)\times (0,1)\\
% \varphi(t,0)=varphi(t,1)=0  & \mbox{on}\hspace{0.10 cm} (0,T)\\
% \varphi(0,x)=0  & \mbox{in}\hspace{0.10 cm}  (0,1).
% \end{cases}
% \end{equation*}
% Then, we set
% q(t,x)=\varphi(T-t,x), thus finishing.

%% STEP 1. We define grev(t,x)=g(T-t,x),
%we extract from source the values at nodes in (0,T]\times (0,1) and
%we transpose the obtained matrix.

Nt=size(source,1);
Nx=size(source,2);
sourcered=zeros(Nx-2,Nt-1);
for i=1:Nx-2
    for k=1:Nt-1
        sourcered(i,k)=source(Nt+1-(k+1),i+1);
    end
end

%% STEP 2. We determine \varphi by the solution by a semi-explicit scheme.

[M,A]=buildMatrices(Nx-2);

varphitmp=zeros(Nx-2,Nt);
%By the above definition, we have already imposed the initial condition
%\varphi(0,x)=0.

for k=2:Nt
      varphitmp(:,k)=(inv(((Nt-1)/T)*M+A))*(-3*transpose(state(Nt+2-k,2:Nx-1).^2).*varphitmp(:,k-1)*(1/(Nx-1))+sourcered(:,k-1)*(1/(Nx-1))+((Nt-1)/T)*M*varphitmp(:,k-1)); 
end

%we transpose the solution matrix.
varphitmp=transpose(varphitmp);
zero=zeros(Nt,1);
varphi=[zero,varphitmp,zero];

%% STEP 3. We determine p(t,x)=\varphi(T-t,x).

p=zeros(Nt,Nx);
for k=1:Nt
    p(k,:)=varphi(Nt+1-k,:);
end
end