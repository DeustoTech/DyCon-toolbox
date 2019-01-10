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
    var1 = input('Enter a value for the   death rate of susceptibles   muS : ');
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
%%
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

%             subplot(3,2,5);plot(y1(1,:),y1(6,:))
%             subplot(3,2,5);xlabel('Time')
%             subplot(3,2,5);ylabel(' Later Latents')

              subplot(3,2,6);plot(y1(1,:),y1(7,:))
             subplot(3,2,6);xlabel('Time')
             subplot(3,2,6);ylabel(' TB infectious')

             subplot(3,2,5);plot(y1(1,:),y1(6,:))
             subplot(3,2,5);xlabel('Time')
             subplot(3,2,5);ylabel('  TB vaccine coverage')
              subplot(3,2,5);axis([0 T -0.1 1])
%               subplot(3,2,8);plot(y1(1,:),y1(9,:))
%             subplot(3,2,8);xlabel('Time')
%             subplot(3,2,8);ylabel('Vaccine coverage')
%             subplot(3,2,8);axis([0 T -0.1 1])
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
    legend('First value','Second value')



    subplot(3,2,4);plot(y1(1,:),y1(5,:),'b',y2(1,:),y2(5,:),'g')
    subplot(3,2,4);xlabel('Time')
    subplot(3,2,4);ylabel('Earlier Latents')
    subplot(3,2,4);legend('First value','Second value')


%     subplot(3,2,5);plot(y1(1,:),y1(6,:),'b',y2(1,:),y2(6,:),'g')
%     subplot(3,2,5);xlabel('Time')
%     subplot(3,2,5);ylabel(' Later latents')
%     subplot(3,2,5);legend('First value','Second value',0)



    subplot(3,2,6);plot(y1(1,:),y1(7,:),'b',y2(1,:),y2(7,:),'g')
    subplot(3,2,6);xlabel('Time')
    subplot(3,2,6);ylabel(' TB infectious')
    subplot(3,2,6);legend('First value','Second value')






    subplot(3,2,5);plot(y1(1,:),y1(6,:),'b',y2(1,:),y2(6,:),'g')
    subplot(3,2,5);xlabel('Time')
    subplot(3,2,5);ylabel('Vaccine coverage')
    subplot(3,2,5);legend('First value','Second value')
    if(var3==10)
        subplot(3,2,5);axis([0 max(T,T2) -0.1 1])
    else
        subplot(3,2,5);axis([0 T -0.1 1])
    end
end
