% Skript to run

%initial conditions
y1= @(x) 2*sin(pi*x);
y2= @(x) sin(pi*x);


%non linearities

a=5;
c=1;
G2 = @(x) -c*x*(x-a)*(x+a);
G1 = @(y) 10*y*exp(-y*y);

% Simulations for SLSD1d model B
N=35;
beta=10^(-15);


%First
[a1,b1,c1,O1]=SLSD1sparse(N,1/3,G1,2,beta,[0.33,0.66],y1);
%Second
[a2,b2,c2,O2]=SLSD1sparse(N,1/3,G2,2,beta,[0.33,0.66],y2);
file='skript_for_jesus_35.m';
location=which(file);
location=replace(location,file,'');
save([location,'DomenecSimulations_0.mat']);

%First
[a1A,b1A,c1A,O1A]=SLSD1sparse(N,1/3,@(x)(N^2)*G1(x),2,beta,[0.33,0.66],y1);
%Second
[a2A,b2A,c2A,O2A]=SLSD1sparse(N,1/3,@(x)(N^2)*G2(x),2,beta,[0.33,0.66],y2);
%Third


% Simulations for CB model 

save([location,'DomenecSimulations_1.mat']);

%First
[a1CB1,b1CB1,c1CB1,OC1B1]=SLSD1sparse(N,1/(3*N^2),G1,2,beta,[0.33,0.66],y1);
[a1CB2,b1CB2,c1CB2,OC1B2]=SLSD1sparse(N,1/(3*N^2),@(x)G1(x)/(N^2),2,beta,[0.33,0.66],y1);
save([location,'DomenecSimulations_2.mat']);
%Second
[a2CB1,b2CB1,c2CB1,O2CB1]=SLSD1sparse(N,1/(3*N^2),G2,2,beta,[0.33,0.66],y2);
[a2CB2,b2CB2,c2CB2,O2CB2]=SLSD1sparse(N,1/(3*N^2),@(x)G2(x)/(N^2),2,beta,[0.33,0.66],y2);
%Third





%%%%%%%%%%%%%%%%%%%%%%%%%%




% Simulations for CB



save([location,'DomenecSimulations_3.mat']);


