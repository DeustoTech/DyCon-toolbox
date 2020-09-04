%%
MU=[0.100 0.050 0.020 0.010 0.005 0.003 0.001 0.0003 0.0002 0.0001 0.0005];
%MU=[0.100 0.050 0.020 0.010 0.005 0.003];
%%
N=20;
%
tic
y = zeros(N,N,length(MU));
m = zeros(N,N,length(MU));

parfor i=1:length(MU)
    %from 1000 to 2000
    [y(:,:,i),m(:,:,i)]=gradientElliptic(MU(i),N,1,0.6,1);
end
total_time = toc;
%%
for i=1:length(MU)
    figure(i)
    plotell(y(:,:,i),m(:,:,i),N,MU(i))
end
