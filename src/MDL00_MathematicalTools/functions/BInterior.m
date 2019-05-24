function [B] = BInterior(mesh,a,b,min)


N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

if nargin > 3
    B =  B(:,control == 1);
end

end