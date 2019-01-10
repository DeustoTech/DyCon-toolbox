function y = codetuberculosesida(pi1, pi2, pi3, beta, varepsilon, muvih,sigma, theta1, theta2, p,...
muS, muV, muE, omega, muL,nu,muI, tau, A, T, S0, V0, Svih0,E0, L0, I0 )

test = -1;

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
    
     for i = 1:M
       
        
        m11 = pi1- beta*S(i)*I(i)-(varepsilon+u(i)+muS)*S(i);
        m12 =  pi2+u(i)*S(i)-theta1*beta*V(i)-muV*V(i)  ;
        m13 =    pi3+varepsilon*S(i)-theta2*beta* Svih(i)*I(i)-muvih*Svih(i);
        m14 =  beta*S(i)+ theta1*beta*V(i)*I(i) + theta2*beta* Svih(i)*I(i)+ (omega+muE)*E (i) ;
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
%         m11 = lambda1(j)*(d + c*I(j) + u(j)) - c*lambda2(j)*I(j);
%         m12 = lambda2(j)*(e + d) - lambda3(j)*e;
%         m13 = -A + (lambda1(j) - lambda2(j))*c*S(j) + lambda3(j)*(g+a+d) + lambda4(j)*a;
%         m14 = -lambda1(j)*b - lambda4(j)*(b-d);
        
        m11= (lambda1(j) -lambda4(j))*beta*I(j) +lambda1(j)*(muS +u(j)+varepsilon)-lambda2(j)*u(j)-lambda3(j)*varepsilon;
        m12= (lambda2 (j)-lambda4(j))*theta1 *beta *I(j) +lambda2(j)*muV ;  
        m13= ( lambda3 (j)-lambda4(j))*theta2 *beta *I (j)+lambda3(j)*muvih;
        m14= lambda4(j)*(muE+omega);
        m15= lambda5(j)*(muL+nu);
        m16=lambda6(j)*(muI+tau)-A ;
        
%         m21 = (lambda1(j)-h2*m11)*(d + c*0.5*(I(j) + I(j-1)) + 0.5*(u(j) + u(j-1))) - c*(lambda2(j)-h2*m12)*0.5*(I(j) + I(j-1));
%         m22 = (lambda2(j)-h2*m12)*(e + d) - (lambda3(j)-h2*m13)*e;
%         m23 = -A + ((lambda1(j)-h2*m11) - (lambda2(j)-h2*m12))*c*0.5*(S(j) + S(j-1)) + (lambda3(j)-h2*m13)*(g+a+d) + (lambda4(j)-h2*m14)*a;
%         m24 = -(lambda1(j)-h2*m11)*b - (lambda4(j)-h2*m14)*(b-d);
%         
        m21=(lambda1(j)-h2*m11) - (lambda4(j)-h2*m14)*beta*0.5*(I(j)-I(j-1))+(lambda1(j)-h2*m11)*(muS +0.5*(u(j)-(j-1))+varepsilon)-(lambda2(j)-h2*m12)*0.5*(u(j)+u(j-1))-(lambda3(j)-h2*m13)*varepsilon;
        
        m22=((lambda2(j)-h2*m12)-(lambda4(j)-h2*m14))*theta1 *beta *0.5*(I(j)-I(j-1))+(lambda2(j)-h2*m12)*muV;  
        m23= ((lambda3(j)-h2*m13)-(lambda4(j)-h2*m14))*theta2*beta *0.5*(I (j)-I(j-1))+(lambda3(j)-h2*m13)*muvih;
        m24=(lambda4(j)-h2*m14)*(muE+omega);
        m25=(lambda5(j)-h2*m15)*(muL+nu);
        m26=(lambda6(j)-h2*m16)*(muI+tau)-A;
        
        
        
%         m31 = (lambda1(j)-h2*m21)*(d + c*0.5*(I(j) + I(j-1)) + 0.5*(u(j) + u(j-1))) - c*(lambda2(j)-h2*m22)*0.5*(I(j) + I(j-1));
%         m32 = (lambda2(j)-h2*m22)*(e + d) - (lambda3(j)-h2*m23)*e;
%         m33 = -A + ((lambda1(j)-h2*m21) - (lambda2(j)-h2*m22))*c*0.5*(S(j) + S(j-1)) + (lambda3(j)-h2*m23)*(g+a+d) + (lambda4(j)-h2*m24)*a;
%         m34 = -(lambda1(j)-h2*m21)*b - (lambda4(j)-h2*m24)*(b-d);
        
        
        
        m31=((lambda1(j)-h2*m21)-(lambda4(j)-h2*m24))*beta*0.5*(I(j)-I(j-1)) +(lambda1(j)-h2*m21)*(muS +0.5*(u (j)-(j-1))+.....
        varepsilon)-(lambda2(j)-h2*m22)*0.5*(u(j)+u(j-1))-(lambda3(j)-h2*m23)*varepsilon;
        m32=((lambda2 (j)-h2*m22)-(lambda4(j)-h2*m24))*theta1 *beta *0.5*(I(j)-I(j-1) )+(lambda2(j)-h2*m22)*muV ;  
        m33=((lambda3 (j)-h2*m23 )-(lambda4(j)-h2*m24))*theta2 *beta *0.5*(I (j)-I(j-1))+(lambda3 (j)-h2*m23)*muvih    ;
        m34=(lambda4(j)-h2*m24)*(muE+omega);
        m35=(lambda5(j)-h2*m25)*(muL+nu);
        m36=(lambda6(j)-h2*m26)*(muI+tau)-A;
        
        
        
        
%         m41 = (lambda1(j)-h*m31)*(d + c*I(j-1) + u(j-1)) - c*(lambda2(j)-h*m32)*I(j-1);
%         m42 = (lambda2(j)-h*m32)*(e + d) - (lambda3(j)-h*m33)*e;
%         m43 = -A + ((lambda1(j)-h*m31) - (lambda2(j)-h*m32))*c*S(j-1) + (lambda3(j)-h*m33)*(g+a+d) + (lambda4(j)-h*m34)*a;
%         m44 = -(lambda1(j)-h*m31)*b - (lambda4(j)-h*m34)*(b-d);


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

    
      
%        temp=(S.*lambda1)./2;
%     u1 = min(0.9,max(0,temp));
%     u = 0.5*(u1 + oldu);
%     
%     temp1 = delta*sum(abs(u)) - sum(abs(oldu - u));
%     temp2 = delta*sum(abs(S)) - sum(abs(oldS - S));
%     temp3 = delta*sum(abs(E)) - sum(abs(oldE - E));
%     temp4 = delta*sum(abs(I)) - sum(abs(oldI - I));
%     temp5 = delta*sum(abs(N)) - sum(abs(oldN - N));
%     temp6 = delta*sum(abs(lambda1)) - sum(abs(oldlambda1 - lambda1));
%     temp7 = delta*sum(abs(lambda2)) - sum(abs(oldlambda2 - lambda2));
%     temp8 = delta*sum(abs(lambda3)) - sum(abs(oldlambda3 - lambda3));
%     temp9 = delta*sum(abs(lambda4)) - sum(abs(oldlambda4 - lambda4));
%     test = min(temp1, min(temp2, min(temp3, min(temp4, min(temp5, min(temp6, min(temp7, min(temp8, temp9))))))));
% end
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




