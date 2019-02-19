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
N=5;
beta=10^(-11);


%First
[a1,b1,c1]=SLSD1doptimalnullcontrol(N,1/3,G1,2,beta,[0.33,0.66],y1);
%Second
[a2,b2,c2]=SLSD1doptimalnullcontrol(N,1/3,G2,2,beta,[0.33,0.66],y2);


%First
[a1A,b1A,c1A]=SLSD1doptimalnullcontrol(N,1/3,@(x)(N^2)*G1(x),2,beta,[0.33,0.66],y1);
%Second
[a2A,b2A,c2A]=SLSD1doptimalnullcontrol(N,1/3,@(x)(N^2)*G2(x),2,beta,[0.33,0.66],y2);
%Third


% Simulations for CB model 

save('DomenecSimulations_0');

%First
[a1CB1,b1CB1,c1CB1]=SLSD1doptimalnullcontrol(N,1/(3*N^2),G1,2,beta,[0.33,0.66],y1);
[a1CB2,b1CB2,c1CB2]=SLSD1doptimalnullcontrol(N,1/(3*N^2),@(x)G1(x)/(N^2),2,beta,[0.33,0.66],y1);
%Second
[a2CB1,b2CB1,c2CB1]=SLSD1doptimalnullcontrol(N,1/(3*N^2),G2,2,beta,[0.33,0.66],y2);
[a2CB2,b2CB2,c2CB2]=SLSD1doptimalnullcontrol(N,1/(3*N^2),@(x)G2(x)/(N^2),2,beta,[0.33,0.66],y2);
%Third




save('DomenecSimulations_1');
%%%%%%%%%%%%%%%%%%%%%%%%%%




% Simulations for CB



save('DomenecSimulations_2');


