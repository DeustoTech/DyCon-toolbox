function B = BInterior2D(xline,yline,x1,x2,y1,y2)
    controly = (yline > y1).*(yline < y2);
    %
    Bx = BInterior(xline,x1,x2);
    
    dimx = length(xline);
    dimy = length(yline);
    
    dim = dimx*dimy;
    
    B = zeros(dim,dim);
    
    iter = 0;
    for ilog = controly
        iter = iter + 1;
        if ilog == 1
            ii = (iter-1)*dimx + 1;
            ei = iter*dimx;
           B(ii :ei,ii :ei) =  Bx;
        end
    end
    %
end

