function A = FDLaplacial2D(xline,yline,varargin)

p = inputParser;

addRequired(p,'xline')
addRequired(p,'yline')
addOptional(p,'Diffusion',1)

parse(p,xline,yline,varargin{:})

D = p.Results.Diffusion;

n1=length(xline);
n2=length(yline);
dx=xline(2)-xline(1);
dy=yline(2)-yline(1);

mainy = ones(n2,1);
Atil = D*spdiags([-(1/(dy^2))*mainy (2/(dx^2) + 2/(dy^2))*mainy -1/(dy^2)*mainy], -1:1, n2, n2);
I = -(D/(dx^2))*speye(n2);

A = blktridiag(Atil,I,I,n1);
A = -sparse(A);

end
