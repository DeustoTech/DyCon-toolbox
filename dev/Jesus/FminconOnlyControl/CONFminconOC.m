    function [c,ceqDyn,dc,dceqDyn] = CONFminconOC(u,p)
        
        c = [];
        dc = [];
        
        [~ , y] = solve(p.dynamics,'Control',u);
        
        ceqDyn = y(end,:) - p.ytarget';
        
        
        dceqDyn = zeros(p.dynamics.Nt*p.dynamics.Udim,p.dynamics.Ydim);
        dceqDyn = p.M;
    end