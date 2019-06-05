function M = MassMatrix(mesh)

dx = mesh(2) - mesh(1);
N = length(mesh);

M=2/3*eye(N);
for i=2:N-1
    M(i,i+1)=1/6;
    M(i,i-1)=1/6;
end
M(1,2)=1/6;
M(N,N-1)=1/6;

M=dx*sparse(M);

end

