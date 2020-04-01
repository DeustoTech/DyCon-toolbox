function [ thetanew ] = mod2pi( thetaold )
%returns x mod2pi (positive number)
    thetanew = ( thetaold>=0 )*(mod(thetaold,2*pi)) +  ...
               ~( thetaold>=0 )*(thetaold+ceil(abs(thetaold)/(2*pi))*2*pi);

end