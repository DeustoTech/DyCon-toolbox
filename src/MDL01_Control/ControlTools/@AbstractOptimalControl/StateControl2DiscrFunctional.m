function varargout  = StateControl2DiscrFunctional(iCP,State,Control)
    % Give the Control Problem this function give a control U(t) you obtain
    % the functional value
    %%
     Jvalue = GetNumericalFunctional(iCP,State,Control);
     varargout{1} = Jvalue;
     
     if nargout > 1
        tspan  = iCP.Dynamics.tspan;
        Nt     = iCP.Dynamics.Nt;
        dLdU   = iCP.Functional.LagrangeDerivatives.Control.Num;
        dLdY   = iCP.Functional.LagrangeDerivatives.State.Num;
        dPsidY = iCP.Functional.TerminalCostDerivatives.State.Num;
        dt     = iCP.Dynamics.dt;
        dPsidYnum =  dPsidY(tspan(end),State(end,:)');
                
        dLdYnum = arrayfun(@(it) dLdY(tspan(it),State(it,:)',Control(it,:)'),1:Nt-1,'UniformOutput',false);
        dLdYnum = dt*[dLdYnum{:}];
        
        dLdUnum = arrayfun(@(it) dLdU(tspan(it),State(it,:)',Control(it,:)'),1:Nt-1,'UniformOutput',false);
        dLdUnum = dt*[dLdUnum{:}];
        
        varargout{2} = sparse([dLdYnum'   dLdUnum'; ...
                               dPsidYnum  zeros(1,iCP.Dynamics.ControlDimension)]);
     end
end