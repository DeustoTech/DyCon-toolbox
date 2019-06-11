function [xline,yline] = xyciclo(xf,yf)

    %
    g = 9.8;
   
    
    syms theta Cp
    eqn = (theta - sin(theta))/xf == (  1   - cos(theta))/yf;
    
    solution = 0;
    while abs(solution) < 0.1
        solution = vpasolve(eqn,theta,'random',true);
        solution = double(solution);
    end
    
    A = yf/(1-cos(solution));
    
    thetaline = linspace(0,solution,500);
    
    xline = A*(thetaline - sin(thetaline));
    yline = A*(    1     - cos(thetaline));
    
    
end

