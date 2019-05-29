function varargout = OBJFminconOC(urow,p)

    u = reshape(urow,p.dynamics.Nt,p.dynamics.Udim);
    dx = p.dynamics.mesh(2) - p.dynamics.mesh(1);
    dt = p.dynamics.dt;
    L = abs(urow); % integrand
    %
    varargout{1} = dx*dt*sum(sum(L));
    %
    if nargout > 1
        varargout{2} = dx*dt*sign(u);
    end
end