rng(0,'twister'); 
% For reproducibility 
n = 20; 

x = linspace(-10,10,n)'; 
y = linspace(-10,10,n)';

[xms,yms] = meshgrid(x,y);

zms = exp(-yms.^2-xms.^2)  + 0.1*randn(n,n);
z = exp(-y.^2-x.^2)  + 0.1*randn(n,1);

surf(xms,yms,zms); shading interp

%%
gprMdl = fitrgp([x y],z,'Basis','linear','FitMethod','exact','PredictMethod','exact');
%%
zpred = predict(gprMdl);
clf
patch(x,y,zpred,zpred); 