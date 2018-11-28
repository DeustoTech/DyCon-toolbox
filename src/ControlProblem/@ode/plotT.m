function plotT(iode)
%PLOTINT Summary of this function goes here
%   Detailed explanation goes here
Y = iode.Y;
[nrow ncol] = size(Y);

line(1:ncol,Y(:,end),'Parent',ax,'Marker','*','LineStyle','-');

        
end

