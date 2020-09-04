clear 
rng(0,'twister'); 
% For reproducibility 
n = 1000;
x1 = linspace(-10,10,n)';
x2 = linspace(-10,10,n)';

y = [1 + x1*5e-2 + sin(x2)./x1 + 0.2*randn(n,1)];


gprMdl = fitrgp([x1 x2],y);
ypred = resubPredict(gprMdl);
%%
plot(x2,y,'b.'); 
hold on; 
plot(x2,ypred,'r','LineWidth',1.5); 
xlabel('x');
ylabel('y'); 
legend('Data','GPR predictions'); 
hold off
