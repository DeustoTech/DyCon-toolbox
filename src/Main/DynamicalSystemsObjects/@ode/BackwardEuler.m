function varargout = BackwardEuler(iode,Control)

%%
State = ZerosState(iode);
State(:,1) = iode.InitialCondition;
%
F = iode.DynamicFcn;

%%
for it = 2:iode.Nt
    dt = iode.tspan(it) - iode.tspan(it-1);
    State(:,it) = full(State(:,it-1) + dt*F(iode.tspan(it-1),State(:,it-1),Control(:,it-1)));
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

