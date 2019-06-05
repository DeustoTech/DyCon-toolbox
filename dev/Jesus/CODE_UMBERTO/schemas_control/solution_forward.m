%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Solution to the direct problem 
%%%%
%%%% u_t + (-d_x^2)^s u = f, (x,t) in (-1,1)x(0,T)                   
%%%% u=0,                    (x,t) in [R\(-1,1)]x(0,T)               
%%%% u(0)=u_0,                x in (-1,1)                            
%%%%
%%%% using implicit Euler method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [soly]=solution_forward(y0,adjoint,donnees,matrices)
        
        soly=zeros(size(y0,1),donnees.Nt+1);
        dt=donnees.T/donnees.Nt;  
        soly(:,1)=y0;
        for i=1:donnees.Nt
            soly(:,i+1)=matrices.C\(soly(:,i) ...
				  + dt*matrices.B*matrices.B'*adjoint(:,i));
        end
end