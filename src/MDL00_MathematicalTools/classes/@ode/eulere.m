function [tline,yline] = eulere(iode)

    tline = iode.tspan;
    yline = zeros(length(tline),length(iode.StateVector.Symbolic));
    yline(1,:) = iode.InitialCondition;
    u0    = iode.Control.Numeric;
    odefun = iode.DynamicEquation.Num;
    params = [iode.Params.value];
    for i=1:length(tline)-1
        vector = odefun(tline(i),yline(i,:)',u0(i,:)',params)';
        yline(i+1,:) = yline(i,:) + vector*(tline(i+1)-tline(i));
    end        
end
