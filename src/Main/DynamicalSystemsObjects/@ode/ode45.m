function State = ode45(iode,Control)

% Catch Optional Parameters in variable with short name
Control = p.Results.Control;
%%
CompatibleControl(iode,Control);
%%
u = @(t) interp1(iode.tspan,Control',t)';
[~,State] = ode45(@(t,x) full(iode.DynamicFcn(t,x,u(t))),iode.tspan,iode.InitialCondition);
State = State';
%% Save the solution in dsys object
iode.Control.num = Control;
iode.State.num = Control;

%% Setting Output Parameters
switch nargout
    case 1
        varargout{1} = State;
end
end

