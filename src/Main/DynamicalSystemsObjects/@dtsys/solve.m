function varargout = solve(isys,varargin)

%% Setting and Validation of Input Parameters  
p = inputParser;

addRequired(p,'isys')
addOptional(p,'Control',ZerosControl(isys))

parse(p,isys,varargin{:})
% Catch Optional Parameters in variable with short name
Control = p.Results.Control;
%%
State = ZerosState(isys);
State(:,1) = isys.InitialCondition;
%%
for it = 2:isys.Nt
    State(:,it) = full(isys.DynamicFcn(it-1,State(:,it-1),Control(:,it-1)));
end
%% Save the solution in dsys object
isys.Control.num = Control;
isys.State.num = Control;

%% Setting Output Parameters
switch nargout
    case 1
        varargout{1} = State;
end
end

