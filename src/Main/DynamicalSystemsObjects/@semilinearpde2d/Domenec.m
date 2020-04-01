function varargout = Domenec(iode,varargin)

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
n = iode.StateDimension;
A = iode.A;
B = iode.B;
%
NLT = iode.NonLinearTerm;%
Ys  = iode.State.sym;

g = casadi.Function('g',{Ys},{NLT(Ys(1))./Ys(1)});

%
for it = 2:iode.Nt
    dt = iode.tspan(it) - iode.tspan(it-1);
    C  = full(diag(1-dt*g(State(:,it-1))) - dt*A);
    yu = State(:,it-1)  + B*Control(:,it-1);
    State(:,it) = C\yu;
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

