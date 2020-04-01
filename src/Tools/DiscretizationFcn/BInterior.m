function [B] = BInterior(mesh,a,b,varargin)

p = inputParser;

addRequired(p,'mesh');
addRequired(p,'a');
addRequired(p,'b');

addOptional(p,'min',false)
addOptional(p,'mass',false)

parse(p,mesh,a,b,varargin{:})

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

if p.Results.mass
    N = length(mesh);
    dx = mesh(2) - mesh(1);
    aux=sparse(N,N);
    
    for i=2:N-1
        aux(i,i) = 1;
        aux(i,i+1) = 0.5;
        aux(i,i-1) = 0.5;
    end
    aux(1,1) = 1;
    aux(1,2) = 0.5;
    aux(N,N-1) = 0.5;
    aux(N,N) = 1;

    B = dx*B*aux;
end

if p.Results.min
    B =  B(:,control == 1);
end


    
    
end