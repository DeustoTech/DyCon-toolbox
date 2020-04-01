function varargout = CrankNicolson(iode,varargin)

%% Setting and Validation of Input Parameters  
p = inputParser;

addRequired(p,'iode')
addOptional(p,'Control',ZerosControl(iode))

parse(p,iode,varargin{:})
% Catch Optional Parameters in variable with short name
Control = p.Results.Control;
%%
State = ZerosState(iode);
State(:,1) = iode.InitialCondition;
%
F = iode.DynamicFcn;
for it = 2:iode.Nt
    dt = iode.tspan(it) - iode.tspan(it-1);
    Fn1 = F(iode.tspan(it),State(:,it),Control(:,it));
    Fn2 = F(iode.tspan(it-1),State(:,it-1),Control(:,it-1));
    State(:,it) = full(State(:,it-1) + 0.5*dt*(Fn1 + Fn2));
end
%% Save the solution in dsys object
iode.Control.num = Control;
iode.State.num = Control;

%% Setting Output Parameters
switch nargout
    case 1
        varargout{1} = State;
end
end

