function varargout = ode23(iode,Control)

%%
CompatibleControl(iode,Control);
%%
u = @(t) interp1(iode.tspan,Control',t)';
[~,State] = ode23(@(t,x) full(iode.DynamicFcn(t,x,u(t))),iode.tspan,iode.InitialCondition);
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

