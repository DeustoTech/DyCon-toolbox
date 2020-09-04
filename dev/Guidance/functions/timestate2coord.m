function [ue,ve,ud,vd] = timestate2coord(State,Ne,Nd,Nt)

ue = reshape(State(:,1           : 2*Ne      ),Nt,2,Ne);
ve = reshape(State(:,2*Ne+1      : 4*Ne      ),Nt,2,Ne);
ud = reshape(State(:,4*Ne+1      : 4*Ne+2*Nd ),Nt,2,Nd);
vd = reshape(State(:,4*Ne+2*Nd+1 : end       ),Nt,2,Nd);

end

