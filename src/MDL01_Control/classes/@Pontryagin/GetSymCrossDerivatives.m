function GetSymCrossDerivatives(iCP)
    idyn  = iCP.Dynamics;

    sY = idyn.StateVector.Symbolic;
    sU = idyn.Control.Symbolic;
    st = idyn.symt;
    %
    iFun = iCP.Functional;
    %
    dL_dU = iFun.LagrangeDerivatives.Control.Sym;
    dL_dY = iFun.LagrangeDerivatives.State.Sym;
    %%
    % Control - Control
    d2L_dU2  = jacobian(dL_dU,sU);
    iFun.LagrangeDerivatives.ControlControl.Sym = d2L_dU2; 
    iFun.LagrangeDerivatives.ControlControl.Num = matlabFunction(d2L_dU2,'Vars',{st,sY,sU}); 
    % State-State
    d2L_dY2  = jacobian(dL_dY,sY);
    iFun.LagrangeDerivatives.StateState.Sym = d2L_dY2; 
    iFun.LagrangeDerivatives.StateState.Num = matlabFunction(d2L_dY2,'Vars',{st,sY,sU}); 
    % State-Control
    d2L_dYdU  = jacobian(dL_dY,sU);
    iFun.LagrangeDerivatives.StateControl.Sym = d2L_dYdU; 
    iFun.LagrangeDerivatives.StateControl.Num = matlabFunction(d2L_dYdU,'Vars',{st,sY,sU}); 
    %
    %
    dPsi_dY = iFun.TerminalCostDerivatives.State.Sym;
    d2Psi_dY2 = jacobian(dPsi_dY,sY);
    iFun.TerminalCostDerivatives.StateState.Sym  = d2Psi_dY2;
    iFun.TerminalCostDerivatives.StateState.Num  = matlabFunction(d2Psi_dY2,'Vars',{st,sY});

end


