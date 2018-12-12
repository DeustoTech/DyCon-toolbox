classdef tuberculosis_GUI < handle
    %TUBERCULOSIS_GUI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        figure
        tuberculosis_layers = tuberculosis_layer
        label_parameters    = {'pi1'  ,'pi2'  ,'pi3'  ,'alpha' ,'varepsilon','omega' ,'sigma'   ,'theta1'  ,'theta2'  ,'beta'  ,'A'   ,'muvih'    ,'p','nu'   ,'muS'  ,'muE'  ,'muL'  ,'muI'  ,'tau'};
        latex_parameters    = {'\pi_1','\pi_2','\pi_3','\alpha','\epsilon'  ,'\omega','\sigma'   ,'\theta_1','\theta_2','\beta' ,'A'   ,'\mu_{vih}','p','\mu_S','\mu_V','\mu_E','\mu_L','\mu_I','\tau'};
        label_initial       = {'Svih0'      ,'S0' ,'V0' ,'E0' ,'L0' ,'I0' ,'T'};
        latex_initial       = {'S_{vih}_{0}','S_0','V_0','E_0','L_0','I_0','T'};
    end
    
end
