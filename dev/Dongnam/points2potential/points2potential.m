function varargout = points2potential(r1,r2,varargin)
% /*******************************************************
%  * Copyright (C) 2019- Jesus Oroya - djoroya@gmail.com
%  *
%  * This file is part of DyCon Toolbox.
%  * 
%  * DyCon Toolbox can not be copied and/or distributed without the express
%  * permission of Chair of Computational Matematics
%    (https://cmc.deusto.eus/)
%  *******************************************************/
%% Figure Settings
p = inputParser;
addRequired(p,'r1')
addRequired(p,'r2')
addOptional(p,'xlim',[-10 10])
addOptional(p,'ylim',[-10 10])
addOptional(p,'dim',[100 100])
addOptional(p,'width',1.5)

parse(p,r1,r2,varargin{:})

xlim = p.Results.xlim;
ylim = p.Results.ylim;
dim = p.Results.dim;
width = p.Results.width;
%%
xmin =  xlim(1);
xmax =  xlim(2);
ymin =  ylim(1);
ymax =  ylim(2);
%
% calculate de module and angle of vector r2 - r1 
module  = norm(r2-r1);
rcenter = r2-r1;
angle   = atan2(rcenter(2),rcenter(1));
% Create the mesh
Nx = dim(1); Ny=dim(2);
xline = linspace(xmin,xmax,Nx);
yline = linspace(ymin,ymax,Ny);
[xms,yms] = meshgrid(xline,yline);

% rotate a translate the variables
xmsrot =   cos(angle)*(xms - r1(1)) + sin(angle)*(yms - r1(2));
ymsrot = - sin(angle)*(xms - r1(1)) + cos(angle)*(yms - r1(2));

% In x-axis create de wall 
k = 15;
thetaHev  = @(x) (1+exp(-k*x)).^(-1);
windowFcn = @(x,a,b) thetaHev(x-a) + thetaHev(-(x-b)) - 1;
zms       = windowFcn(xmsrot,0,module);
zms       = zms.*windowFcn(ymsrot,-0.25*width,0.25*width);

% for differents number of outputs 
switch nargout 
    case 1
        varargout{1} = zms;
    case 2 
        varargout{1} = zms;
        varargout{2} = xms;
    case 3 
        varargout{1} = zms;
        varargout{2} = xms;
        varargout{3} = yms;
end