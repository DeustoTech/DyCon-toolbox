clear all;
%%
Nx = 20;
xl = linspace(-3,3,Nx);
%
Ny = 30;
vl = linspace(-3,3,Ny);
%
Na = 3;
al = linspace(-10,10,Na);
%%
%
states  = Nx*Ny;
actions = Na;
%
MDP = createMDP(states,actions);
env = rlMDPEnv(MDP);
%

%