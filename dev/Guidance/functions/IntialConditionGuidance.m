function State0 = IntialConditionGuidance(Ne,Nd)

Ne_sqrt= sqrt(Ne);

ve_zero = zeros(2, Ne);
vd_zero = zeros(2, Nd);
ue_zero = zeros(2, Ne);
ud_zero = zeros(2, Nd);

x_zero = 5*repmat(linspace(-1,1,Ne_sqrt),[Ne_sqrt 1]);
y_zero = (1/5)*x_zero';

x_zero = x_zero + 10*rand(size(x_zero)) + 15*0.5*(rand(size(x_zero))-0.5) ;
y_zero = y_zero + 10*rand(size(y_zero)) + 15*0.5*(rand(size(y_zero))-0.5) ;

ue_zero(1,:) = x_zero(:);
ue_zero(2,:) = y_zero(:);


% Ponemos los drivers en un circulo alrededor
angles = linspace(0,2*pi,Nd+1);
angles = angles(1:end-1);
%
ud_zero(1,:) = 10*cos(angles) -10 + 10*(rand(size(ud_zero(1,:) ))-0.5) ;
ud_zero(2,:) = 10*sin(angles) -10 + 10*(rand(size(ud_zero(2,:) ))-0.5) ;


State0 = [ue_zero(:);ve_zero(:);ud_zero(:);vd_zero(:)];


end

