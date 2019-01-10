%%
% we solve an ODE  epidemic system  and applied optimal control.
%The Pontryagin's maximum principle is used to characterize the optimal control. 
%The optimality system  is derived and solved numerically  using the Runge Kutta fourth procedure
%Our model consists of the following system of ordinary differential equations
%%
% \begin{equation}
%\left\{\begin{array}{r c l}
%\label{system}
%\dot{S}&=&\pi_1-\beta SI-(\mu_S+\varepsilon +\alpha) S , \\\\
%\dot{V}&=& \pi_2 +\alpha S - \theta_1\beta V \,I -\mu_V V\\\\
%\dot{S_{vih}}&=& \pi_3 +\varepsilon S-\mu_{vih} S_{vih}-\theta_2\beta S_{vih}I, \\\\
%\dot{E}&=&\beta SI+\theta_2\beta S_{vih}I +\theta_1\beta VI -(\mu_E+\omega)E, \\\\
%\dot{L}&=&(1-p)\omega E-(\mu_L+\nu)L, \\\\
%\dot{I}&=&p\omega E+\nu L-(\mu_I+\tau  )I,\\\\
%\dot{R}&= \tau I -\mu_R \\\\
  % N &= &S + S_{vih} + V + E + L+ I+ R
%\end{array}\right.
%\end{equation}
%with initial conditions $(S(0), S_{vih}(0), V(0) E(0), L(0), I(0) R(0))\in \mathbb{R}^5_+$.//
%We have also $$\theta_2 = 1+\sigma \,\mbox{ and}\, \sigma=1-Tcd4 $$
% With initial conditions $ S( 0 ) $, $ E( 0 ) $, $ I( 0 )  $ $ R( 0 ) $ $ \geqslant 0 $
%

%compartmental sheme 
% ![](extradata/diagramme48.PNG  )

%%STEP0
% 
%  we seek to minimise the infectious group with the minimum  possible of vaccine coverage .
%We consider an optimal control problem to minimize the objective functional
%\begin{equation}
 %\min_u \int_1^T I + A u_1(t)^2 +  \textrm{d}x
%\end{equation}


%\begin{equation}
%\begin{array}{rcl}
%\label{system2}
%\mbox{subject to }   \,\dot{S(t)}&=&\pi_1-\beta S (t)I(t)-(\mu_S+u (t) +\varepsilon)) S \, \,, S(0)= S_0 \\
%\dot{V(t)}&=& \pi_2 +u_1(t) S(t)- \theta_1\beta V(t) \,I(t) -\mu_V V(t)  \,\, , V(0)= S_0\\
%\dot{S_{vih}(t)}&=& \pi_3 + \varepsilon ) S-\mu_{vih} S_{vih}(t)-\theta_2\beta S_{vih}(t)I(t) \,\, , S_{vih} (0)= S_{vih0} \\
%\dot{E(t)}&=&\beta S(t)I(t)+\theta_2\beta S_{vih}(t)I(t) +\theta_1\beta V(t)I(t) -(\mu_E+\omega)E(t)\,\,, E(0)=E_0  \\
%\dot{L(t)}&=&(1-p)\omega E(t)-(\mu_L+\nu)L(t)\,\, , L(0)= L_0  \\
%\dot{I(t)}&=&p\omega E(t)+\nu L(t)-(\mu_I+\tau  )I(t) \,\,, I(0)=I_0\\
%0 \leq u(t) \leq 0.8 \\

%\end{array}.
%\end{equation}


%% STEP1
%We create a matlab file that we call codetuberculosesida.m
%where we write all the code to solve our optimization problem
%%
%STEP2 we create a function codetuberculossida and declare parameters 

%The numerical algorithm presented below is a classical Rung -Kutta four method.
%We discretize the interval [t0,tf] at the points ti = t0 + ih ( i = 0,1,...,n), where h is the
%time step such that tn = tf = M , h2 = h/2 and j = M + 2 ? i .

function y = codetuberculosesida(pi1, pi2, pi3, beta, varepsilon, muvih,sigma, theta1, theta2, p,...
muS, muV, muE, omega, muL,nu,muI, tau, A, T, S0, V0, Svih0,E0, L0, I0 )

% here we give the time step h ,
 %Next, we initialize the state and adjoint variables $S(t)$, $S_{vih}(t)$,  
 %$V(t)$  $E(t)$, $R(t)$   $I(t)$ , $\lambda_1(t)$, $\lambda_2(t)$,
 %$\lambda_3(t)$, $\lambda_4(t)$, $\lambda_5(t)$, $\lambda_6(t)$ )and the
 %control u.

delta = 0.001;
M = 1000;
t=linspace(0,T,M+1);
h=T/M;
h2 = h/2;
S=zeros(1,M+1);
V=zeros(1,M+1);
Svih=zeros(1,M+1);
E=zeros(1,M+1);
L=zeros(1,M+1);
I=zeros(1,M+1);
S(1)=S0;
V(1)=V0;
Svih(1)=Svih0;
E(1)=E0;
L(1)=L0;
I(1)=I0;
lambda1=zeros(1,M+1);
lambda2=zeros(1,M+1);
lambda3=zeros(1,M+1);
lambda4=zeros(1,M+1);
lambda5=zeros(1,M+1);
lambda6=zeros(1,M+1);
u=zeros(1,M+1);

while(test < 0)
    
    oldu = u;
    oldS = S;
    oldV = V;
    oldSvih=Svih;
    oldE = E;
    oldL = L;
    oldI=I;
    
    
    oldlambda1 = lambda1;
    oldlambda2 = lambda2;
    oldlambda3 = lambda3;
    oldlambda4 = lambda4;
    oldlambda5 = lambda5;
    oldlambda6 = lambda6;
    
    %%STEP3
    % Now a combination of forward and backward difference approximation is used as follows
    
    
    for i = 1:M
       
        
        m11 = pi1- beta*S(i)*I(i)-(varepsilon+u(i)+muS)*S(i);
        m12 =  pi2+u(i)*S(i)-theta1*beta*V(i)-muV*V(i)  ;
        m13 =    pi3+varepsilon*S(i)-theta2*beta* Svih(i)*I(i)-muvih*Svih(i);
        m14 =  beta*S(i)*I(i)+ theta1*beta*V(i)+ theta2*beta* Svih(i)*I(i)+ (omega+muE)*E (i) ;
        m15 = (1-p)*omega*E(i)-(muL+nu)*L(i);
        m16 =  p*omega*E (i) +nu*L(i)-(muI+tau)*I(i);
        
        m21 = pi1- beta*(S(i)+h2*m11)*(I(i)+h2*m16) -(varepsilon+ 0.5*(u(i) +u(i+1))+muS)*(S(i)+h2*m11 );
        m22 =  pi2+0.5*(u(i)+u(i+1))*(S(i)+h2*m11)-theta1*beta*(V(i) +h2*m12)*(I(i)+h2*m16)   -muV* (V(i)+h2*m12)  ;
        m23 =    pi3+varepsilon*(S(i)+h2*m11 )-theta2*beta* (Svih(i)+h2*m13 )*  (I(i) +h2*m16)-muvih* (Svih(i)+h2*m13 );
        m24 = beta*(S(i)+h2*m11)*(I(i)+h2*m16)+ theta1*beta*(V(i) +h2*m12)*(I(i)+h2*m16)+ theta2*beta* (Svih(i)+h2*m13 )*(I(i)+h2*m16) + (omega+muE)*(E(i)+h2*m14) ;
        m25 = (1-p)*omega*(E(i)+h2*m14)  -(muL+nu)*(L(i) +h2*m15);
        m26 =  p*omega*(E(i)+h2*m14) +nu*(L(i)+h2*m15)-(muI+tau)*(I(i)+h2*m16);
        
        
         m31 = pi1- beta*(S(i)+h2*m21)*(I(i)+h2*m26) -(varepsilon+0.5*(u(i)+u(i+1))+muS)*(S(i)+h2*m21 );
        m32 =  pi2+0.5*(u(i)+u(i+1))*(S(i)+h2*m21)-theta1*beta*(V(i) +h2*m22)*(I(i)+h2*m26)   -muV* (V(i)+h2*m22)  ;
        m33 =    pi3+varepsilon*(S(i)+h2*m21 )-theta2*beta* (Svih(i)+h2*m23 )*  (I(i) +h2*m26)-muvih* (Svih(i)+h2*m23 );
        m34 = beta*(S(i)+h2*m21)*(I(i)+h2*m26)+ theta1*beta*(V(i) +h2*m22)*(I(i)+h2*m26)+ theta2*beta* (Svih(i)+h2*m23 )*(I(i)+h2*m26) + (omega+muE)*(E(i)+h2*m24) ;
        m35 = (1-p)*omega*(E(i)+h2*m24) -(muL+nu)*(L(i) +h2*m25);
        m36 =  p*omega*(E(i)+h2*m24) +nu*(L(i)+h2*m25)-(muI+tau)*(I(i)+h2*m26);
        
        m41 = pi1- beta*(S(i)+h*m31)*(I(i)+h*m36) -(varepsilon+u(i+1)+muS)*(S(i)+h*m31 );
        m42 =  pi2+u(i+1)*(S(i)+h*m31)-theta1*beta*(V(i) +h*m32)*(I(i)+h*m36)   -muV* (V(i)+h*m32)  ;
        m43 =    pi3+varepsilon*(S(i)+h*m31 )-theta2*beta* (Svih(i)+h*m33 )*  (I(i) +h*m36)-muvih* (Svih(i)+h*m33 );
        m44 = beta*(S(i)+h*m31)*(I(i)+h*m36)+ theta1*beta*(V(i) +h*m32)*(I(i)+h*m36)+ theta2*beta*(Svih(i)+h*m33 )*(I(i)+h2*m36) + (omega+muE)*(E(i)+h*m34) ;
        m45 = (1-p)*omega*(E(i)+h*m34) -(muL+nu)*(L(i) +h*m35);
        m46 =  p*omega*(E(i)+h*m34) +nu*(L(i)+h*m35)-(muI+tau)*(I(i)+h*m36);
       
       
       S(i+1) = S(i) + (h/6)*(m11 + 2*m21 + 2*m31 + m41);
      V(i+1) = V(i) + (h/6)*(m12 + 2*m22 + 2*m32 + m42);
      Svih(i+1) =Svih(i) + (h/6)*(m13 + 2*m23 + 2*m33 + m43);
      E(i+1) = E(i) + (h/6)*(m14 + 2*m24 + 2*m34 + m44);
      L(i+1)= L(i)+ (h/6)* (m15+2*m25+2*m35+m45);
      I(i+1)=I(i)+(h/6)* (m16+2*m26+2*m36+m46);
    end
    
    
      for i = 1:M
        j = M + 2 - i;

   %%STEP 4  
   % By using a similar technique, we approximate the time derivative of the adjoint variables by their ?rst order backward-difference and we use the appropriated scheme as follows, notice that as i counts forward from $1$ to M
%here j counts backward from M+1 to $2$
        
        m11= (lambda1(j) -lambda4(j))*beta*I(j) +lambda1(j)*(muS +u(j)+varepsilon)-lambda2(j)*u(j)-lambda3(j)*varepsilon;
        m12= (lambda2 (j)-lambda4(j))*theta1 *beta *I(j) +lambda2(j)*muV ;  
        m13= ( lambda3 (j)-lambda4(j))*theta2 *beta *I (j)+lambda3(j)*muvih;
        m14= lambda4(j)*(muE+omega);
        m15= lambda5(j)*(muL+nu);
        m16=lambda6(j)*(muI+tau)-A ;
        

        m21=(lambda1(j)-h2*m11) - (lambda4(j)-h2*m14)*beta*0.5*(I(j)-I(j-1))+(lambda1(j)-h2*m11)*(muS +0.5*(u(j)-(j-1))+varepsilon)-(lambda2(j)-h2*m12)*0.5*(u(j)+u(j-1))-(lambda3(j)-h2*m13)*varepsilon;
        
        m22=((lambda2(j)-h2*m12)-(lambda4(j)-h2*m14))*theta1 *beta *0.5*(I(j)-I(j-1))+(lambda2(j)-h2*m12)*muV;  
        m23= ((lambda3(j)-h2*m13)-(lambda4(j)-h2*m14))*theta2*beta *0.5*(I (j)-I(j-1))+(lambda3(j)-h2*m13)*muvih;
        m24=(lambda4(j)-h2*m14)*(muE+omega);
        m25=(lambda5(j)-h2*m15)*(muL+nu);
        m26=(lambda6(j)-h2*m16)*(muI+tau)-A;
        
        
        

        
        m31=((lambda1(j)-h2*m21)-(lambda4(j)-h2*m24))*beta*0.5*(I(j)-I(j-1)) +(lambda1(j)-h2*m21)*(muS +0.5*(u (j)-(j-1))+.....
        varepsilon)-(lambda2(j)-h2*m22)*0.5*(u(j)+u(j-1))-(lambda3(j)-h2*m23)*varepsilon;
        m32=((lambda2 (j)-h2*m22)-(lambda4(j)-h2*m24))*theta1 *beta *0.5*(I(j)-I(j-1) )+(lambda2(j)-h2*m22)*muV ;  
        m33=((lambda3 (j)-h2*m23 )-(lambda4(j)-h2*m24))*theta2 *beta *0.5*(I (j)-I(j-1))+(lambda3 (j)-h2*m23)*muvih    ;
        m34=(lambda4(j)-h2*m24)*(muE+omega);
        m35=(lambda5(j)-h2*m25)*(muL+nu);
        m36=(lambda6(j)-h2*m26)*(muI+tau)-A;
        
        
         m41= (lambda1(j)-h*m31)-(lambda4(j)-h*m34)*beta*I(j-1) +.....
        (lambda1(j)-h*m31)*(muS +u(j-1)+varepsilon)-(lambda2(j)-h*m32)*u(j-1)-(lambda3(j)-h*m33 )*varepsilon;
        m42= ((lambda2 (j)-h*m32)-(lambda4(j)-h*m34))*theta1 *beta *I(j-1)+(lambda2(j)-h*m32)*muV ;  
        m43= ((lambda3(j)-h*m33 )-(lambda4(j)-h*m24))*theta2 *beta *0.5*(I (j)-I(j-1))+(lambda3 (j)-h*m23)*muvih    ;
        m44=( lambda4(j)-h*m34)*(muE+omega);
        m45= (lambda5(j)-h*m35)* (muL+nu);
        m46= (lambda6(j)-h*m36) *(muI+tau)-A;
        
        
        
        
        lambda1(j-1) = lambda1(j) - (h/6)*(m11 + 2*m21 + 2*m31 + m41);
        lambda2(j-1) = lambda2(j) - (h/6)*(m12 + 2*m22 + 2*m32 + m42);
        lambda3(j-1) = lambda3(j) - (h/6)*(m13 + 2*m23 + 2*m33 + m43);
        lambda4(j-1) = lambda4(j) - (h/6)*(m14 + 2*m24 + 2*m34 + m44);
        lambda5(j-1) = lambda5(j) - (h/6)*(m15 + 2*m25 + 2*m35 + m45);
        lambda6(j-1) = lambda6(j) - (h/6)*(m16 + 2*m26 + 2*m36 + m46);
  
      end

    %%STEP 5
    %Now we compute our optimal solution
      
%       
temp =S.*(lambda1-lambda2)./2;
u1= min(0.8, max (0, temp));
u=0.5*(u1+oldu);
temp1= delta*sum(abs(u))-sum(abs(oldu-u));
temp2=delta*sum(abs(S))-sum(abs(oldS-S));
temp3=delta*sum(abs(V))-sum(abs(oldV-V));
temp4=delta*sum(abs(Svih))-sum(abs(oldSvih - Svih));
temp5=delta*sum(abs(E))-sum(abs(oldE-E));
temp6=delta*sum(abs(L))-sum(abs(oldL-L));
temp7=delta*sum(abs(I))-sum(abs(oldI-I));
temp8=delta*sum(abs(lambda1))-sum(abs(oldlambda1-lambda1));
temp9=delta*sum(abs(lambda2))-sum(abs(oldlambda2-lambda2));
temp10=delta*sum(abs(lambda3))-sum(abs(oldlambda3-lambda3));
temp11=delta*sum(abs(lambda4))-sum(abs(oldlambda4-lambda4));
temp12=delta*sum(abs(lambda5))-sum(abs(oldlambda5-lambda5));
temp13=delta*sum(abs(lambda6))-sum(abs(oldlambda6-lambda6));
test= min (temp1, min (temp2, min(temp3, min(temp4, min(temp5, min(temp6, min(temp7, min(temp8, min(temp8, min(temp9, min(temp10, min(temp11, min(temp12, temp13)))))))))))));
      
end

y(1,:) = t;
y(2,:) = S;
y(3,:) = V;
y(4,:) = Svih;
y(5,:) = E;
y(6,:) = L;
y(7,:) = I;
Y(8,:)=u;


%%STEP 6
%in order to plot the trajectories of our epidemic system and control optimal u
%we have to create another matlab file , and that we call labtuberculosesida.m where we whrite  the following matlab code
%at the end, to run our system, we don't need to be an matlab expert, we have just to call in command window the file: 
%codetuberculosesida.m and the system will ask you to enter gradually 
%all parameters values and then will run the ODE system with optimal control curve also 


close

flag1=0;
flag2=0;
flag3=0;
flag4=0;
    
while(flag1==0)    
    var1 = input('Enter a value for number of susceptible rescued at birth pi1: ');
    if(var1 > 0)
        pi1 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: pi1 must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for  number of vaccinated rescued at birth pi2  : ');
    if(var1 > 0)
        pi2 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: pi2 must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('            ')
while(flag1==0)    
    var1 = input('Enter a value for  number of VIH/AIDS patients rescued at birth pi3  : ');
    if(var1 > 0)
        pi3 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: pi3 must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('           ')
while(flag1==0)    
    var1 = input('Enter a value for vaccination coverage alpha: ');
    if(var1 > 0)
        alpha = var1;
        flag1=1; 
    else
        disp('        ')
        disp('ERROR: alpha must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('              ')
while(flag1==0)    
    var1 = input('Enter a value for AIDS prevalence varepsilon,: ');
    if(var1 >= 0)
        varepsilon = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: varepsilon must be non-negative.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for progression rate to latent earlier stage omega: ');
    if(var1 > 0)
        omega = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: omega must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for immune deficiency rate sigma: ');
    if(var1 >= 0)
        sigma = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: sigma must be non-negative.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for theta2: ');
    if(var1 >= 0)
        theta2 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: theta2 must be non-negative.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for vaccine efficacity theta1 ): ');
    if(var1 >= 0)
        theta1 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: theta2 must be non-negative.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)    
    var1 = input('Enter a value for the Effective contact rate beta : ');
    if(var1 >= 0)
        beta = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: beta must be non-negative.')
        disp('         ')
    end
end
flag1=0;
disp('         ')
while(flag1==0)
    var1 = input('Enter a value for the weight parameter A: ');
    if(var1>=0)
        A = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: A must be non-negative.')
        disp('        ')
    end
    
    
    
end

flag1=0;
disp('         ')
while(flag1==0)
    var1 = input('Enter a value for the    VIH specific death rate muvih     : ');
    if(var1>=0)
        muvih = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR:  muvih  must be non-negative.')
        disp('        ')
    end
    
end
 
flag1=0;
disp('         ')
   while(flag1==0)
    var1 = input('Enter a value for the   fraction of individuals who progress directly in TB active stage p : ');
    if(var1>=0)
        p = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: p must be non-negative.')
        disp('        ')
    end
    
   end 
    
   flag1=0;
disp('         ')
 while(flag1==0)
    var1 = input('Enter a value for the    Progression rate to active disease nu    : ');
    if(var1>=0)
        nu = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: nu must be non-negative.')
        disp('        ')
    end
    
 end 
   
   flag1=0;
disp('         ')

 
  while(flag1==0)
    var1 = input('Enter a value for the   initial value of susceptible S0    : ');
    if(var1>=0)
        S0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: S0 must be non-negative.')
        disp('        ')
    end
  end  
 
flag1=0;
disp('         ')
  while(flag1==0)
    var1 = input('Enter a value for the   initial value of vaccinated  V0 : ');
    if(var1>=0)
        V0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: V0 must be non-negative.')
        disp('        ')
    end
    
  end
 flag1=0;
disp('         ')
  while(flag1==0)
    var1 = input('Enter a value for the   initial value of ADIS PATIENTS   Svih0    : ');
    if(var1>=0)
        Svih0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR:Svih0   must be non-negative.')
        disp('        ')
    end
    
  end 
   flag1=0;
disp('         ')
  
 while(flag1==0)
    var1 = input('Enter a value for the   initial value of  earlier latents E0    : ');
    if(var1>=0)
        E0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: E0   must be non-negative.')
        disp('        ')
    end
    
 end 
 flag1=0;
disp('         ')

  while(flag1==0)
    var1 = input('Enter a value for the   initial value of  later latents L0    : ');
    if(var1>=0)
        L0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: L0   must be non-negative.')
        disp('        ')
    end
    
  end 
  flag1=0;
disp('         ')

  
  while(flag1==0)
    var1 = input('Enter a value for the   initial value of  TB infectious  I0    : ');
    if(var1>=0)
        I0 = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: I0   must be non-negative.')
        disp('        ')
    end
    
  end 
  flag1=0;
disp('         ')

  
  while(flag1==0)
    var1 = input('Enter a value for the   death rate of susceptibles   muS    : ');
    if(var1>=0)
        muS = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: muS   must be non-negative.')
        disp('        ')
    end
    
  end 
 flag1=0;
disp('         ')

  
  while(flag1==0)
    var1 = input('Enter a value for the   death rate of vaccinated people   muV    : ');
    if(var1>=0)
        muV = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: muV   must be non-negative.')
        disp('        ')
    end
    
  end 
  
  flag1=0;
disp('         ')
  
while(flag1==0)
    var1 = input('Enter a value for the   death rate of   earlier latents           muE    : ');
    if(var1>=0)
        muE = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: muE   must be non-negative.')
        disp('        ')
    end
    
end 
  flag1=0;
disp('         ')

while(flag1==0)
    var1 = input('Enter a value for the   death rate of   later latents           muL    : ');
    if(var1>=0)
        muL = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: muL   must be non-negative.')
        disp('        ')
    end
    
end 
  flag1=0;
disp('         ')
  while(flag1==0)
    var1 = input('Enter a value for the   death rate of  TB infectious           muI    : ');
    if(var1>=0)
        muI = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: muI   must be non-negative.')
        disp('        ')
    end
    
  end 
  flag1=0;
disp('         ')
 while(flag1==0)
    var1 = input('Enter a value for the   removal rate of  TB infectious           tau    : ');
    if(var1>=0)
        tau = var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: tau   must be non-negative.')
        disp('        ')
    end
 end 
    
  
  
  
  
flag1=0;
disp('          ')
while(flag1==0)
    var1 = input('How many years would you like to run this system: ');
    if(var1>0)
        T=var1;
        flag1=1;
    else
        disp('        ')
        disp('ERROR: T must be positive.')
        disp('         ')
    end
end
flag1=0;
disp('              ')
disp('One moment please...')
 y1=codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih, theta1,sigma, theta2, p,...
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 

disp('               ')

while(flag2==0)
    disp('Would you like to vary any parameters?')
    disp('1. Yes')
    disp('2. No')
    var2=input('Type 1 or 2: ');
%         y1 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih, theta1, theta2, p,
% muS, muE, omega, mul,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 

    
    if(var2==1)
        disp('         ')
        flag2=1;
        while(flag3==0)
            disp('Which parameter would you like to vary?')
            disp('1. pi1')
            disp('2. pi2')
            disp('3. pi3')
            disp('4. alpha')
            disp('5. beta')
            disp('6. varepsilon')
            disp('7,muvih')
            disp('8. theta1')
            disp('9. theta2')
           disp('10. p')
            disp('11. muS')
            disp('12. muE')
            disp('13. omega')
            disp('14. muL')
            disp( '15.nu')
            disp('16,muI')
             disp('17. tau')
             disp('18. A')
            disp('19. T')
            disp('20. S0')
             disp('21. V0')
            disp('22. Svih0')
            disp('23. E0')
            disp('24. L0')
            disp('25. I0')
            
            
           
            
             var3 = input('Type 1 - 25: ');
            if(var3==1)
                disp('        ')
                while(flag4==0)
                    var4 = input('Enter a second pi1 value: ');
                    if(var4 > 0)
                        b2 = var4;
                        flag4 = 1;
                    else
                        disp('            ')
                        disp('ERROR: pi1 must be positive.')
                        disp('       ')
                    end
                end
                disp('       ')
                disp('One moment please...')

                flag3=1;
            elseif(var3==2)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second pi2 value: ');
                    if(var4 > 0)
                        pi22 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: pi2 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma ,theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                               
                flag3=1;
            elseif(var3==3)
                disp('        ')
                while(flag4==0)
                    var4 = input('Enter a second pi3 value: ');
                    if(var4 > 0)
                        pi32 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: pi3 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
  y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 

             elseif(var3==4)
                disp('        ')
                while(flag4==0)
                   var4=input('Enter a second alpha value: ');
                   if(var4 > 0)
                       alpha2 = var4;
                       flag4 = 1;
                   else
                       disp('      ')
                       disp('ERROR: alpha must be positive.')
                       disp('        ')
                   end
                end
                disp('            ')
                disp('One moment please...')
                     y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==5)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second  beta value: ');
                    if(var4 >= 0)
                        beta2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: beta must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                
                
                
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,...
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==6)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second  varepsilon value: ');
                    if(var4 >= 0)
                        varepsilon2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: varepsilon must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                   y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==7)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second muvih value: ');
                    if(var4 > 0)
                        muvih2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: muvih must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih, sigma,theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==8)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second theta1 value: ');
                    if(var4 >= 0)
                        theta12 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: theta1 must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 );
                flag3=1;
            elseif(var3==9)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second theta2 value: ');
                    if(var4 >= 0)
                        theta22 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: theta2 must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
  y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, sigma,muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==10)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second p value: ');
                    if(var4 >= 0)
                        p2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: p must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
  y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==11)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second muS value: ');
                    if(var4 >= 0)
                        muS2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: muS must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==12)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second muE value: ');
                    if(var4 >= 0)
                        muE2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: muE must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                  
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==13)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second omega value: ');
                    if(var4 >= 0)
                        omega2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: omega must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                  
                   y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==14)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a mul omega value: ');
                    if(var4 >= 0)
                        mul2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: mul must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==15)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a nu omega value: ');
                    if(var4 >= 0)
                        nu2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: nu must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==16)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a muI omega value: ');
                    if(var4 >= 0)
                        muI2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: muI2 must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,.....
muS, muE, omega, muL,nu,mul, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==17)
                disp('        ')
                while(flag4==0)
                    var4=input('Enter a second tau value: ');
                    if(var4 >= 0)
                        tau2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: tau must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
  y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==18)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second A value: ');
                    if(var4 >= 0)
                        A2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: A must be non-negative.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
  y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==19)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second T value: ');
                    if(var4 > 0)
                        T2 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: T must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')

           y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon,sigma, muvih, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==20)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second S0 value: ');
                    if(var4 > 0)
                        S02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: S0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                   y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta,sigma, varepsilon, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==21)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second V0 value: ');
                    if(var4 > 0)
                        V02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: V0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta,sigma, varepsilon, muvih, theta1, theta2, p,.....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==22)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second Svih0 value: ');
                    if(var4 > 0)
                        Svih02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: Svih0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta,sigma, varepsilon, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T,   S0, V0, Svih0,E0, L0, I0 ); 
                
                             
                flag3=1;
            elseif(var3==23)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second E0 value: ');
                    if(var4 > 0)
                        E02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: E0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                 y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta,sigma, varepsilon, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                  
                flag3=1;
            elseif(var3==24)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second L0 value: ');
                    if(var4 > 0)
                        L02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: L0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                   y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta,sigma, varepsilon, muvih, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                flag3=1;
            elseif(var3==25)
                disp('           ')
                while(flag4==0)
                    var4=input('Enter a second I0 value: ');
                    if(var4 > 0)
                        I02 = var4;
                        flag4 = 1;
                    else
                        disp('      ')
                        disp('ERROR: I0 must be positive.')
                        disp('        ')
                    end
                end
                disp('            ')
                disp('One moment please...')
                
                y2 = codetuberculosesida(pi1, pi2, pi3, alpha, beta, varepsilon, muvih,sigma, theta1, theta2, p,....
muS, muE, omega, muL,nu,muI, tau , A, T, S0, V0, Svih0,E0, L0, I0 ); 
                
                flag3=1;
            else
                disp('         ')
                disp('Pardon?')
                disp('           ')
            end
        end
%             
    elseif(var2==2)
            disp('            ')
            flag2=1;           
            subplot(3,2,1);plot(y1(1,:),y1(2,:))
            subplot(3,2,1);xlabel('Time')
            subplot(3,2,1);ylabel('Susceptible')

            subplot(3,2,2);plot(y1(1,:),y1(3,:))
            subplot(3,2,2);xlabel('Time')
            subplot(3,2,2);ylabel('vaccinated')

            subplot(3,2,3);plot(y1(1,:),y1(4,:))
            subplot(3,2,3);xlabel('Time')
            subplot(3,2,3);ylabel('Aids patients')

            subplot(3,2,4);plot(y1(1,:),y1(5,:))
            subplot(3,2,4);xlabel('Time')
            subplot(3,2,4);ylabel(' Earlier latents')



              subplot(3,2,6);plot(y1(1,:),y1(7,:))
             subplot(3,2,6);xlabel('Time')
             subplot(3,2,6);ylabel(' TB infectious')

             subplot(3,2,5);plot(y1(1,:),y1(6,:))
             subplot(3,2,5);xlabel('Time')
             subplot(3,2,5);ylabel('  TB vaccine coverage')
              subplot(3,2,5);axis([0 T -0.1 1])

    else 
        disp('     ')
        disp('Pardon?')
        disp('          ')
    end
end

if(var2==1)
    subplot(3,2,1);plot(y1(1,:),y1(2,:),'b',y2(1,:),y2(2,:),'g')
    subplot(3,2,1);xlabel('Time')
    subplot(3,2,1);ylabel('Susceptible')
    subplot(3,2,1);
    
    legend('First value','Second value','best')
 

subplot(3,2,2);plot(y1(1,:),y1(3,:),'b',y2(1,:),y2(3,:),'g')
subplot(3,2,2);xlabel('Time')
subplot(3,2,2);ylabel('vaccinated')
subplot(3,2,2);
legend('First value','Second value','best')




    subplot(3,2,3);plot(y1(1,:),y1(4,:),'b',y2(1,:),y2(4,:),'g')
    subplot(3,2,3);xlabel('Time')
    subplot(3,2,3);ylabel('Aids patients')
    subplot(3,2,3);
    legend('First value','Second value','best')



    subplot(3,2,4);plot(y1(1,:),y1(5,:),'b',y2(1,:),y2(5,:),'g')
    subplot(3,2,4);xlabel('Time')
    subplot(3,2,4);ylabel('Earlier Latents')
    subplot(3,2,4);legend('First value','Second value','best')


%     subplot(3,2,5);plot(y1(1,:),y1(6,:),'b',y2(1,:),y2(6,:),'g')
%     subplot(3,2,5);xlabel('Time')
%     subplot(3,2,5);ylabel(' Later latents')
%     subplot(3,2,5);legend('First value','Second value',0)



    subplot(3,2,6);plot(y1(1,:),y1(7,:),'b',y2(1,:),y2(7,:),'g')
    subplot(3,2,6);xlabel('Time')
    subplot(3,2,6);ylabel(' TB infectious')
    subplot(3,2,6);legend('First value','Second value','best')






    subplot(3,2,5);plot(y1(1,:),y1(6,:),'b',y2(1,:),y2(6,:),'g')
    subplot(3,2,5);xlabel('Time')
    subplot(3,2,5);ylabel('Vaccine coverage')
    subplot(3,2,5);legend('First value','Second value','best')
    if(var3==10)
        subplot(3,2,5);axis([0 max(T,T2) -0.1 1])
    else
        subplot(3,2,5);axis([0 T -0.1 1])
    end
end

%%

%We will simulate some scenarios, which in turn will give us the optimal vaccination strategy
%corresponding to certain key parameters like number of susceptible rescued at birth\,, 
%number of vaccinated rescued at birth\,,number of VIH/AIDS patients rescued at birth \,, AIDS prevalence\,,
%immune deficiency rate\,,fraction of individuals who progress directly in TB active stage.

 %First scenario 


%%
%  \textbf{  no need for mass vaccination campaign the first fifteen years }\\\\
%With the precedent scenario \ref{system10} the number of vaccinated rescued at birth $\pi_2$  represents the quarter of  number of susceptible rescued at birth $\pi_1,$ the AIDS prevalence $ \varepsilon =0.01 $ and number of VIH/AIDS patients rescued at birth $\pi_3=0.1$  are negligible because close to zero
%With theses values of   we obtain the curves below, and remark that we don't need to control disease the first fifteen years

% ![](extradata/15anneessanscontrolesalpha.png )

%%
%we observe now in the figure below  that from the twentieth year, 
%the population of vaccinated tends to disappear, and it is precisely in the year 20 that the optimal control curve begins.

% ![](extradata/controla20ans.png )

%FIN!











































