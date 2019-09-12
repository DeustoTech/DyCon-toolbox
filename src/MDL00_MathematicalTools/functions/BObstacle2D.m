function B = BObstacle2D(xline,yline,x,y,SizeInX,SizeInY)
%BOBSTACLE2D Summary of this function goes here
%   Detailed explanation goes here

x1 = x - 0.5*SizeInX;
x2 = x + 0.5*SizeInX;
y1 = y - 0.5*SizeInY;
y2 = y + 0.5*SizeInY;

B = BInterior2D(xline,yline,x1,x2,y1,y2);
end

