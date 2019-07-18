function [tline,yline] = tvdrk2(iode)
    tline = iode.tspan;
    yline = zeros(length(tline),length(iode.StateVector.Symbolic));
    yline(1,:) = iode.InitialCondition;
    u0    = iode.Control.Numeric;
    odefunControl = iode.DynamicEquation.Numeric;
    
    ufun = @(t) interp1(tline,u0,t,'nearest')';
    odefun = @(t,y) odefunControl(t,y,ufun(t));
    for i=1:length(tline)-1
        h = tline(i+1)-tline(i);

        yline(i+1,:) = yline(i,:) + odefun(tline(i),yline(i,:)')'*h*0.5;
        yline(i+1,:) = yline(i,:) + odefun(tline(i)+h*0.5,yline(i+1,:)')'*h;
    end        
end
