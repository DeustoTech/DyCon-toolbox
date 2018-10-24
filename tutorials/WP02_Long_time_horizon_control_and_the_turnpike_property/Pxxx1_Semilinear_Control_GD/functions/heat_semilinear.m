function [ y ] = heat_semilinear( nonlin, T, init, source )
%We solve the semilinear heat equation
% \begin{equation*}
% \begin{cases}
% y_t- y_{xx}+nonlin(y)=g\hspace{2.8 cm} & \mbox{in} \hspace{0.10 cm}(0,T)\times (0,1)\\
% y(t,0)=y(t,1)=0  & \mbox{on}\hspace{0.10 cm} (0,T)\\
% y(0,x)=y_0(x)  & \mbox{in}\hspace{0.10 cm}  (0,1).
% \end{cases}
% \end{equation*}


%% STEP 1. We extract from init the values at the INTERIOR nodes.

Nx=length(init);
%error in case
%dimensions Nx ~= size(source,2).
if (Nx ~= size(source,2))
    error('init and source dimensions must agree !!!');
end
%WARNING: We have to fulfill
%Courant-Friedrichs-Levy condition:
%2(\Delta t)\leq (\Delta x)^2.
Nt=size(source,1);
init=init(2:end-1);

%% STEP 2. We extract from source the values at nodes in (0,T]\times (0,1).
%Moreover, we transpose the obtained matrix.

sourcered=zeros(Nx-2,Nt-1);
for i=1:Nx-2
    for k=1:Nt-1
        sourcered(i,k)=source(k+1,i+1);
    end
end

%% STEP 3. We determine the solution by a semi-explicit method
%(see e.g. [3]).

[M,A]=buildMatrices(Nx-2);
ytmp=zeros(Nx-2,Nt);
%We impose the initial condition.
for i=1:Nx-2
   ytmp(i,1)=init(i);
end
%We conpute tthe solution by employing a semi-explicit method.
for k=2:Nt
      ytmp(:,k)=(inv(((Nt-1)/T)*M+A))*(sourcered(:,k-1)*(1/(Nx-1))-nonlin(ytmp(:,k-1))*(1/(Nx-1))+((Nt-1)/T)*M*ytmp(:,k-1)); 
end

%We transpose the matrix of the solution.
ytmp=transpose(ytmp);
zero=zeros(Nt,1);
y=[zero,ytmp,zero];

%% References

%[1] Porretta, Alessio and Zuazua, Enrique, Remarks on long time versus steady state optimal control, Mathematical Paradigms of Climate Science, Springer, 2016, pp. 67--89.

%[2] Casas, Eduardo and Mateos, Mariano, Optimal control of partial differential equations,
%    Computational mathematics, numerical analysis and applications,
%    Springer, Cham, 2017, pp. 3--5.

%[3] Tr{\"o}ltzsch, Fredi, Optimal control of partial differential equations, Graduate studies in mathematics, American Mathematical Society, 2010.

    



end

