function [Y0] = InitialConditionGuidance(Nx,Mx,N_sqrt)

ve_zero = zeros(2, Nx);
vd_zero = zeros(2, Mx);
ue_zero = zeros(2, Nx);
ud_zero = zeros(2, Mx);

x_zero = 0.2*repmat(linspace(-1,1,N_sqrt),[N_sqrt 1]);
y_zero = x_zero';
ue_zero(1,:) = x_zero(:);
ue_zero(2,:) = y_zero(:);

ud_zero(1,:) = [-1];
ud_zero(2,:) = [-1];
Y0 = [ue_zero(:);ve_zero(:);ud_zero(:)];


end

