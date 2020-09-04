%% Two drivers, Flexible time

clear all

% Parameters and the dynamics
Ne_sqrt = 4; 
Ne      = Ne_sqrt^2;
Nd = 2; 
%
Nt = 200; T = 6;
tspan = linspace(0,T,Nt);
%
%Ut = 0.5*[-5;4];
Ut = target([5*(rand-0.5);5*(rand-0.5)]);
%% Define dynamics using CasADi

% FEEDBACK LAW | 

% Matrix de positiones 
fue  = @(State) reshape(State(1:2*Ne) ,2 , Ne);
fve  = @(State) reshape(State(2*Ne+1:4*Ne  ) ,2 , Ne);

fud  = @(State) reshape(State(4*Ne+1:4*Ne+2*Nd ) ,2 , Nd);
fvd  = @(State) reshape(State(4*Ne+2*Nd+1:end  ) ,2 , Nd);
% media y varianza de la distribucion de ovejas 
fuem = @(State) mean(reshape(State(1:2*Ne),2,Ne),2);
fvem = @(State) mean(reshape(State(2*Ne+1:4*Ne),2,Ne),2);


fvari = @(State) (fue(State) - fuem(State))*(fue(State) - fuem(State))';
fvari_vel = @(State) (fve(State) - fvem(State))*(fve(State) - fvem(State))';

power = 5;
fpwmean = @(State) nthroot(sum(reshape(State(1:2*Ne),2,Ne).^power,2)/Ne ,power);
%fuem = @(State) fpwmean(State); % <=== !!!

% perpendicular de un vector en 2D
perp = @(vec)   [vec(2,:) ; -vec(1,:)];

% Norma de un 
normSt    = @(State) sqrt(sum(State.^2));
normalize = @(State) State./normSt(State);

fuem_var = @(State) fuem(normSt(fue(State) - fuem(State)).*fue(State)) / sum(normSt(fue(State) - fuem(State)));

% Function Theta de Heiviside
theta = @(x) 0.5 + 0.5*tanh(5*x);
%
PerpVec = @(State) normalize( perp(fuem(State) - fud(State) ) );
CentVec = @(State) normalize(      fuem(State) - fud(State)   );
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POLICY 1 - Conducir al Target
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CosAng = @(State) sum((fud(State) - fuem(State)).*(Ut.r- fuem(State))) ...               % product escalar
                  ./(normSt((fud(State) - fuem(State))).*normSt((Ut.r - fuem(State))));  % normas

SinAng = @(State) sum((fud(State)-fuem(State)).*flipud((Ut.r-fuem(State))).*[1;-1]) ... % vectorial product
                  ./(normSt((fud(State) - fuem(State))).*normSt((Ut.r - fuem(State))));  % normas


pi = @(State)   PerpVec(State) .* (  -    SinAng(State).*(1+CosAng(State)))  + ...   % fuerza perpendicular 
                0.1*(normSt(fud(State)-fuem(State))').^2.*CentVec(State) .* (  -0.1*CosAng(State)     - 0.05*theta(10-norm(fvari_vel(State))) -1e-3*norm(fvari(State))    ) ;        % fuerza central
 
            pi = @(State) [0;0;0;0]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DYNAMICS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F = @(t,State) DynamicGuidance(State,pi(State),Ne,Nd);
% symF_ftn is the vector field for the dynamics
%% Initial data
State0 = CreateIntialCondition_Guidance(Ne,Nd);
%% Sample trajectory
[tspan,StateTime] = ode23(F,tspan,State0);
%
[ue,ve,ud,vd] = timestate2coord(StateTime,Ne,Nd,Nt);
%% Plot
figure(1)
clf
plotGuidance(ue,ud,Ut.r,Ne,Nd)
%%
liveAnimation(F,State0,Ne,Nd,Ut)