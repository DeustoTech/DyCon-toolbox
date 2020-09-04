function [tnodes,telements] = CreateGeometry()

%t = linspace(0,2*pi,30);
%pgon = polyshape({[0.5*sin(t) ]},{[0.5*cos(t) ]});

pgon = polyshape({[ -1 -1 1 1 ]},{[ -1 1 1 -1 ]});

tr = triangulation(pgon);
%
tnodes = tr.Points';
telements = tr.ConnectivityList';

end

