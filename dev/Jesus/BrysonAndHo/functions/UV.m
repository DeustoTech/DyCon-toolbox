function result = UV(x,y,RdnPoints) 
    
    r = @(x,y) sqrt(x.^2 + y.^2);

    gauss = @(x,y,sigma) exp(-r(x,y).^2./sigma.^2);
    delta = 0.01;

    rot = @(x,y,x0,y0,Fr)    [ -Fr*(gauss(x,y,10)).*(y-y0)./sqrt(delta + (x-x0).^2 + (y-y0).^2) , ...
                                Fr*(gauss(x,y,10)).*(x-x0)./sqrt(delta + (x-x0).^2 + (y-y0).^2) ];
                        
    [nrow,~] = size(RdnPoints);
    
    result = [ x*0 + 1 x*0 + 0 ];
    for i = 1:nrow
        x0i = RdnPoints(i,1);
        y0i = RdnPoints(i,2);
        result = result + rot(x,y, x0i,y0i,1) ;
    end                      
end