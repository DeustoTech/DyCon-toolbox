function [tline,yline] = tvdrk3(iode)
    %works for time-independent problems
    tline = iode.tspan;
    yline = zeros(length(tline),length(iode.StateVector.Symbolic));
    yline(1,:) = iode.InitialCondition;
    u0    = iode.Control.Numeric;
    odefunControl = iode.DynamicEquation.Numeric;
    
    ufun = @(t) interp1(tline,u0,t,'nearest')';
    odefun = @(t,y) odefunControl(t,y,ufun(t));
    for i=1:length(tline)-1
        h = tline(i+1)-tline(i);

        yline(i+1,:) = yline(i,:) + odefun(tline(i),yline(i,:)')'*h;
        yline(i+1,:) = 0.75*yline(i,:) + 0.25*yline(i+1,:) + odefun(tline(i),yline(i+1,:)')'*h*0.25;
        yline(i+1,:) = (1/3)*yline(i,:) + (2/3)*yline(i+1,:) + odefun(tline(i),yline(i+1,:)')'*h*(2/3);
    end        
end
