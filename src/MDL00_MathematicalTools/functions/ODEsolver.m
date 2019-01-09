function [u,ut] =  ODEsolver(M0,K0,ui,uti,f,T,J,Mtemp)
% description: This is a odesolver using mid-point rule for
%               $$M(d^2u/dt^2)=Ku+f$$
% tutorial: P0002_Numerical homogenizaton_for_wave_equation
% author: XinliangL
% MandatoryInputs:   
%  M0: 
%    description: massive matrix 
%    class: double
%    dimension: [nxn]
%  K0:
%    description: stiffness matrix  
%    class: double
%    dimension: [nxn]
%  ui:
%    description: initial value of u
%    class: double
%    dimension: [nx1]
%  uti:
%    description: initial value of ut
%    class: double
%    dimension: [nx1]
%  f:
%    description: source term
%    class: double
%    dimension: [nx1]
%  T:
%    description: time interval
%    class: double
%    dimension: [1x1]
%  J:
%    description: number of time step
%    class: double
%    dimension: [1x1]
% Outputs:
%  u:
%    description: solution
%    class: double
%    dimension: [nx1]
%  ut:
%    description: derivative of solution u
%    class: double
%    dimension: [nx1]

    dt = T/J; N = length(M0);
    A0 = M0 + dt^2/4*K0; A1 = M0 - dt^2/4*K0; C = Mtemp; 
    f0 = f;
    
    u = zeros(N, J+1); u(:, 1) = ui;
    ut = zeros(N, J+1); ut(:, 1) = uti;
    
    for j = 2:J+1
        ut(:, j) = A0\( A1*ut(:, j-1) - K0*dt*u(:, j-1) + C*f0*dt);
        u(:, j) = dt/2*(ut(:, j) + ut(:, j-1)) + u(:, j-1);
    end

end
