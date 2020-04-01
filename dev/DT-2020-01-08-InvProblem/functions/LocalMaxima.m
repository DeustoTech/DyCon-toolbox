function u0 = LocalMaxima(u0,N) % find the local maxima of u0 

U0 = zeros(N+2,2*N+3);
U0(2:end-1,2:end-1) = reshape(u0,N,2*N+1);
Nx=length(U0(:,1));
Ny=length(U0(1,:));
U0post = zeros(Nx,Ny);

for i=2:Nx-1
    for j=2:Ny-1
        around=[U0(i-1,j-1), U0(i,j-1), U0(i+1,j-1), U0(i-1,j), U0(i+1,j), U0(i-1,j+1), U0(i,j+1), U0(i+1,j+1)];
        if(U0(i,j)>max(around))
            U0post(i,j) = U0(i,j);
        end
    end
end
u0 = reshape(U0post(2:end-1,2:end-1),(2*N+1)*N,1);

end