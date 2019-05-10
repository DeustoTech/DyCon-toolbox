function result = dot(iCP,X,Y)

tspan = iCP.Dynamics.tspan;
iode  = iCP.Dynamics;
%
result = arrayfun(@(indextime) X(indextime,:)*iode.MassMatrix*Y(indextime,:).',1:length(tspan));

end