function result = dot(iCP,X,Y)

xline = iCP.Dynamics.mesh{1};
%
result = trapz(X.*Y,xline);

end