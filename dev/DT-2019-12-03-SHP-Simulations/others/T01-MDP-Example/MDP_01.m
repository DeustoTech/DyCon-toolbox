%%
clear all
close all

% Denotaremos x_t \in X 
% Denotaremos a_t \in A
%%
% Matrix de MDP
% M una matrix de dimension [ n x n x m ]
%%    
% Control Izquierda <-
n = 4;

M(:,:,1) = [ [1 zeros(1,n-1)]         ;
             eye(n-1)  zeros(n-1,1)];

% Control Derecha  ->

M(:,:,2) = [ zeros(n-1,1) eye(n-1)  ;
              [zeros(1,n-1) 1]         ];

% Control = 

M(:,:,3) = eye(n);
         
%%
% Donde n es la dimension de x_t, mientras que m es la dimension a_t
[~ ,n,m] = size(M);         
%% Graphs  
% fig = M2plotdigraphs(M);

% V^\pi (t,x) = E[ ]
Aset = 1:m;
Xset = 1:n;

T = 10;

%%
rfcn = @(x,a) -1*(a~=3);
Rfcn = @(x) 10*(x==1) + 5*(x==3) + 6*(x==5);
%%
Vstar = zeros(T,n);
Pi = zeros(T-1,n);
Vstar(T,:) = Rfcn(Xset);
%%
for t = T-1:-1:1
    for xs = Xset
       Vtxa = zeros(1,m);
       for as = Aset
          rc = rfcn(xs,as);
          E_Vb = 0;
          for ys = Xset
            E_Vb = E_Vb + M(xs,ys,as)*Vstar(t+1,ys);
          end
          Vtxa(as) = rc + E_Vb;      
       end
       [Vstar(t,xs) ,Pi(t,xs)] = max(Vtxa);
    end
end
%%
x0 = zeros(n,1);
x0(2) = 1;


% AniMDP(x0,Pi,M,Rfcn)

%%
surf(Vstar)
view(0,90)
colorbar
xlabel('State')
ylabel('Time')
xlim([1 n])
ylim([1 T])

