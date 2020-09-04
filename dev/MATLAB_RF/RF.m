clear 
max_state = +3;
min_state = -3;

Nx = 10;
Nv = 10;

xline = linspace(min_state,max_state,Nx);
vline = linspace(min_state,max_state,Nv);

%Generate a state list
states=cell(Nx*Nv,1); % 2 Column matrix of all possible combinations of the discretized state.
index=1;
for j=1:Nx
    for k = 1:Nv
        states{index} = [ xline(j);vline(k)];
        index=index+1;
    end
end
%

max_control = +3;
min_control = -3;
Na = 5;

actions = linspace(max_control,min_control,Na);

%%
obsinfo   = rlFiniteSetSpec(states);
actinfo   = rlFiniteSetSpec(actions);

%%
env = rlFunctionEnv(obsinfo,actinfo,@myStepFunction,@myResetFunction);

Nt = 500;

state_time = zeros(2,Nt);
rt = zeros(1,Nt);

for it = 1:Nt
   [state_time(:,it),rt(it),IsDone2,LoggedSignals2] = step(env,0);
end

%%
T = rlTable(obsinfo,actinfo)
