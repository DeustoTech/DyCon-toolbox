function result = dot(iCP,X,Y)

tspan = iCP.Dynamics.tspan;
%
result = arrayfun(@(indextime) X(indextime,:)*Y(indextime,:).',1:length(tspan));

end