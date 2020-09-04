function [ue,ve,ud,vd] = state2coord(State,Ne,Nd)

    
    ue = reshape(State(1           : 2*Ne      ,:),2,Ne);
    ve = reshape(State(2*Ne+1      : 4*Ne      ,:),2,Ne);
    ud = reshape(State(4*Ne+1      : 4*Ne+2*Nd ,:),2,Nd);
    vd = reshape(State(4*Ne+2*Nd+1 : end       ,:),2,Nd);

end

