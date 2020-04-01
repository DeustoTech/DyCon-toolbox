function [U0_ref] = initial_deltas(n)
% Reference initial solution

U0=zeros(2*n+1,n);

U0(round((2*n+1)/2)+1,round(3*n/4)) = 85;
U0(round(3*(2*n+1)/4),round(n/2)) = 100;
U0(round((2*n+1)/4),round(n/2)) = 60;
U0(round(3*(2*n+1)/8),round(n/4)) = 90;

U1_0 = U0(1:n,:);
UG_0 = U0(n+1,:);
U2_0 = U0(n+2:end,:);

U0_ref = zeros(2*n+3,n+2);
U0_ref(2:n+1,2:end-1) = U1_0;
U0_ref(n+2,2:end-1) = UG_0;
U0_ref(n+3:end-1,2:end-1) = U2_0;

U0_ref=U0_ref';
end