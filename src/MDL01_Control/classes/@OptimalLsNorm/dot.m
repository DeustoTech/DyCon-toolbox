function result = dot(iCP,X,Y)

tspan = iCP.Dynamics.tspan;
M     = iCP.Dynamics.MassMatrix;
%
result = arrayfun(@(indextime) X(indextime,:)*M*Y(indextime,:).',1:length(tspan));

end