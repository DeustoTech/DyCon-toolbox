function [M,A,V] = computeFEmatrices(N,d1,d2,vx,vy)

[A1,A2,Agg1,Agg2,M1,M2,Mgg1,Mgg2] = compute_matrices(N,d1,d2); % computes FE discretization matrices (mass matrices and stiffness matrices)

V1 = advection_matrix(N,vx,vx); % computes discretization matrices (advection matrix on left subdomain)
V2 = advection_matrix(N,vx,vy); % computes discretization matrices (advection matrix on right subdomain)

[M,A,V] = merge_matrices_2d(A1,A2,Agg1,Agg2,M1,M2,Mgg1,Mgg2,V1,V2); % merges discretization matrices corresponding to left and right subdomains
end