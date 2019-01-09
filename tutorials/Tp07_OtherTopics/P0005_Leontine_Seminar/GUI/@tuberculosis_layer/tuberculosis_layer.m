classdef tuberculosis_layer
    %TUBERCULOSIS_LAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = 'layer_001'
        %Enter a value for number of susceptible rescued at birth pi1: 30
        pi1 = 30;         
    
        % Enter a value for  number of vaccinated rescued at birth pi2  : 0.001
        pi2 = 0.001;           

        % Enter a value for  number of VIH/AIDS patients rescued at birth pi3  : 0.01
        pi3 = 0.01;           

        % Enter a value for vaccination coverage alpha: 0.0001
        alpha = 0.0001;              

        % Enter a value for AIDS prevalence varepsilon,: 0.001
        varepsilon = 0.001;

        % Enter a value for progression rate to latent earlier stage omega: 0.0645
        omega = 0.0645;

        % Enter a value for immune deficiency rate sigma: 0.001
        sigma = 0.001;

        % Enter a value for theta2: 1.001
        theta2 = 1.001;    

        % Enter a value for vaccine efficacity theta1 ): 0.2
        theta1 = 0.2;       

        % Enter a value for the Effective contact rate beta : 0.00001
        beta = 0.00001;

        % Enter a value for the weight parameter A: 1
        A = 1;         

        % Enter a value for the    VIH specific death rate muvih     : 0.05
        muvih = 0.05;

        % Enter a value for the   fraction of individuals who progress directly in TB active stage p : 0.5
        p = 0.5;     

        % Enter a value for the    Progression rate to active disease nu    : 0.00375
        nu = 0.00375;

        % Enter a value for the   initial value of susceptible S0    : 50
        S0 = 50;        

        % Enter a value for the   initial value of vaccinated  V0 : 10
        V0 = 10;         

        % Enter a value for the   initial value of ADIS PATIENTS   Svih0    : 15
        Svih0 = 15;       

        % Enter a value for the   initial value of  earlier latents E0    : 8
        E0 = 8;        

        % Enter a value for the   initial value of  later latents L0    : 7
        L0 = 7;         
        % Enter a value for the   initial value of  TB infectious  I0    : 5
        I0 = 5;   

        % Enter a value for the   death rate of susceptibles   muS : 0.01
        muS = 0.01;     
    
        % Enter a value for the   death rate of vaccinated people   muV    : 0.01
        %muV = 0.01;       
        % Enter a value for the   death rate of   earlier latents           muE    : 0.01
        muE = 0.01;         

        % Enter a value for the   death rate of   later latents           muL    : 0.015
        muL = 0.015; 

        % Enter a value for the   death rate of  TB infectious           muI    : 0.06
        muI = 0.06;      
        
        % Enter a value for the   removal rate of  TB infectious           tau    : 0.25
        tau = 0.25;        

        % How many years would you like to run this system: 100
        T = 100;
        
        result
    end

end

