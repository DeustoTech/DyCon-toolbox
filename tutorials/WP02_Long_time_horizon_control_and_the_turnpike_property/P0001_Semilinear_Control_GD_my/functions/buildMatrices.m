function [M,A]=buildMatrices(Nx)

%[mass matrix,rigidity matrix]=buildMatrices(the number of INTERIOR
%nodes of the discretication)


%Consider a partition P of (0,1)
%Nx is the number of interior nodes.
%Nx+2 is the number of total nodes;
%Nx+1 is the number of subintervals.

	dx=1/(Nx+1);
	A=2*eye(Nx);
    for i=1:Nx-1
        A(i+1,i)=-1;
        A(i,i+1)=-1;
    end
    A=(Nx+1)*A;
    M=(2/3)*eye(Nx);
    for i=1:Nx-1
        M(i+1,i)=1/6;
        M(i,i+1)=1/6;
    end
    M=(dx)*M;
end

